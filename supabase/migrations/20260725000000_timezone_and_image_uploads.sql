-- ==============================================================================
-- 🔧 CKD Nutrition App: Timezone Alignment & Custom Food Images Migration
-- Date: 2026-07-25
-- ==============================================================================

-- 1. Add image_url column to custom_foods table if not exists
ALTER TABLE public.custom_foods
  ADD COLUMN IF NOT EXISTS image_url TEXT;

-- 2. Drop existing log_meal functions to avoid overloading ambiguity
DROP FUNCTION IF EXISTS public.log_meal(text, text, numeric, text, numeric, numeric, numeric, numeric, numeric, numeric);
DROP FUNCTION IF EXISTS public.log_meal(text, text, numeric, text, numeric, numeric, numeric, numeric, numeric, numeric, timestamptz, date);

-- 3. Recreate RPC log_meal to accept p_eaten_at and p_log_date from client
CREATE OR REPLACE FUNCTION public.log_meal(
    p_food_id text,
    p_food_name text,
    p_quantity_g numeric,
    p_meal_type text,
    p_protein numeric,
    p_potassium numeric,
    p_sodium numeric,
    p_sugar numeric,
    p_carb numeric,
    p_water numeric,
    p_eaten_at timestamptz DEFAULT now(),
    p_log_date date DEFAULT null
) RETURNS void AS $$
DECLARE
    v_user_id uuid;
    v_log_id uuid;
    v_target_date date;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- Determine target log date: use client log_date or extract from eaten_at
    IF p_log_date IS NOT NULL THEN
        v_target_date := p_log_date;
    ELSE
        v_target_date := (p_eaten_at AT TIME ZONE 'Asia/Bangkok')::date;
    END IF;

    -- Find or create daily log for the target date
    SELECT id INTO v_log_id FROM public.daily_logs 
    WHERE user_id = v_user_id AND log_date = v_target_date;

    IF NOT FOUND THEN
        INSERT INTO public.daily_logs (user_id, log_date)
        VALUES (v_user_id, v_target_date)
        RETURNING id INTO v_log_id;
    END IF;

    -- Insert meal record
    INSERT INTO public.meals (
        log_id, food_id, food_name, quantity_g, meal_type,
        protein_g, potassium_mg, sodium_mg, sugar_g, carb_g, water_ml, eaten_at
    ) VALUES (
        v_log_id, p_food_id, p_food_name, p_quantity_g, p_meal_type,
        p_protein, p_potassium, p_sodium, p_sugar, p_carb, p_water, COALESCE(p_eaten_at, now())
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. Drop and recreate RPC log_urine to accept p_logged_at and p_log_date
DROP FUNCTION IF EXISTS public.log_urine(numeric);
DROP FUNCTION IF EXISTS public.log_urine(numeric, timestamptz, date);

CREATE OR REPLACE FUNCTION public.log_urine(
    p_amount_ml numeric,
    p_logged_at timestamptz DEFAULT now(),
    p_log_date date DEFAULT null
) RETURNS void AS $$
DECLARE
    v_user_id uuid;
    v_log_id uuid;
    v_target_date date;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    IF p_log_date IS NOT NULL THEN
        v_target_date := p_log_date;
    ELSE
        v_target_date := (p_logged_at AT TIME ZONE 'Asia/Bangkok')::date;
    END IF;

    SELECT id INTO v_log_id FROM public.daily_logs 
    WHERE user_id = v_user_id AND log_date = v_target_date;

    IF NOT FOUND THEN
        INSERT INTO public.daily_logs (user_id, log_date)
        VALUES (v_user_id, v_target_date)
        RETURNING id INTO v_log_id;
    END IF;

    INSERT INTO public.urine_logs (user_id, log_id, amount_ml, logged_at)
    VALUES (v_user_id, v_log_id, p_amount_ml, COALESCE(p_logged_at, now()));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Create storage bucket food_images if not exists
INSERT INTO storage.buckets (id, name, public)
VALUES ('food_images', 'food_images', true)
ON CONFLICT (id) DO NOTHING;

-- 6. Storage RLS Policies for food_images
DROP POLICY IF EXISTS "Public Read Food Images" ON storage.objects;
CREATE POLICY "Public Read Food Images"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'food_images');

DROP POLICY IF EXISTS "Authenticated Upload Food Images" ON storage.objects;
CREATE POLICY "Authenticated Upload Food Images"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'food_images' AND
    auth.role() = 'authenticated'
  );

DROP POLICY IF EXISTS "Authenticated Delete Food Images" ON storage.objects;
CREATE POLICY "Authenticated Delete Food Images"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'food_images' AND
    auth.role() = 'authenticated'
  );
