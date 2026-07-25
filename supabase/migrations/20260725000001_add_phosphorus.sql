-- ==============================================================================
-- 🔧 CKD Nutrition App: Phosphorus Tracking Migration
-- Date: 2026-07-25
-- ==============================================================================

-- 1. Add phosphorus_mg columns to tables
ALTER TABLE public.meals
  ADD COLUMN IF NOT EXISTS phosphorus_mg NUMERIC DEFAULT 0;

ALTER TABLE public.custom_foods
  ADD COLUMN IF NOT EXISTS phosphorus_mg NUMERIC DEFAULT 0;

ALTER TABLE public.daily_logs
  ADD COLUMN IF NOT EXISTS phosphorus_mg NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS phosphorus_limit_mg NUMERIC DEFAULT 1000;

ALTER TABLE public.ckd_rules
  ADD COLUMN IF NOT EXISTS phosphorus_limit_mg NUMERIC DEFAULT 1000;

-- 2. Drop and recreate RPC log_meal to accept p_phosphorus
DROP FUNCTION IF EXISTS public.log_meal(text, text, numeric, text, numeric, numeric, numeric, numeric, numeric, numeric, timestamptz, date);
DROP FUNCTION IF EXISTS public.log_meal(text, text, numeric, text, numeric, numeric, numeric, numeric, numeric, numeric, timestamptz, date, numeric);

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
    p_log_date date DEFAULT null,
    p_phosphorus numeric DEFAULT 0
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
        v_target_date := (p_eaten_at AT TIME ZONE 'Asia/Bangkok')::date;
    END IF;

    SELECT id INTO v_log_id FROM public.daily_logs 
    WHERE user_id = v_user_id AND log_date = v_target_date;

    IF NOT FOUND THEN
        INSERT INTO public.daily_logs (user_id, log_date)
        VALUES (v_user_id, v_target_date)
        RETURNING id INTO v_log_id;
    END IF;

    INSERT INTO public.meals (
        log_id, food_id, food_name, quantity_g, meal_type,
        protein_g, potassium_mg, sodium_mg, sugar_g, carb_g, water_ml, phosphorus_mg, eaten_at
    ) VALUES (
        v_log_id, p_food_id, p_food_name, p_quantity_g, p_meal_type,
        p_protein, p_potassium, p_sodium, p_sugar, p_carb, p_water, COALESCE(p_phosphorus, 0), COALESCE(p_eaten_at, now())
    );

    UPDATE public.daily_logs
    SET 
        total_protein_g = total_protein_g + p_protein,
        total_potassium_mg = total_potassium_mg + p_potassium,
        total_sodium_mg = total_sodium_mg + p_sodium,
        total_sugar_g = total_sugar_g + p_sugar,
        total_carb_g = total_carb_g + p_carb,
        total_water_ml = total_water_ml + p_water,
        phosphorus_mg = COALESCE(phosphorus_mg, 0) + COALESCE(p_phosphorus, 0)
    WHERE id = v_log_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Recreate View dashboard_summary
DROP VIEW IF EXISTS public.dashboard_summary CASCADE;

CREATE OR REPLACE VIEW public.dashboard_summary
WITH (security_invoker = true)
AS
SELECT 
    dl.id,
    dl.user_id,
    dl.log_date,
    dl.total_protein_g,
    dl.total_potassium_mg,
    dl.total_sodium_mg,
    dl.total_sugar_g,
    dl.total_carb_g,
    dl.total_water_ml,
    COALESCE(dl.phosphorus_mg, 0) AS total_phosphorus_mg,
    dl.total_urine_ml,
    hp.ckd_stage,
    hp.weight_kg,
    hp.gender,
    cr.protein_limit_g,
    cr.potassium_limit_mg,
    cr.sodium_limit_mg,
    cr.sugar_limit_g,
    cr.carb_limit_g,
    cr.water_limit_ml,
    COALESCE(cr.phosphorus_limit_mg, 1000) AS phosphorus_limit_mg
FROM public.daily_logs dl
JOIN public.user_health_profiles hp ON dl.user_id = hp.user_id
JOIN public.ckd_rules cr ON hp.ckd_stage = cr.stage
WHERE dl.deleted_at IS NULL;
