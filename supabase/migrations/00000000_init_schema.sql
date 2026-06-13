-- ==============================================================================
-- Baseline Database Schema (Reverse Engineered)
-- นี่คือไฟล์รวมตารางทั้งหมดที่เราเคยสร้างไป เผื่อไว้ใช้เวลาตั้งโปรเจกต์ใหม่ครับ
-- ==============================================================================

-- 1. ตารางกฎข้อบังคับโภชนาการตามระยะโรคไต (CKD Rules)
CREATE TABLE IF NOT EXISTS public.ckd_rules (
    stage text PRIMARY KEY,
    protein_limit_g numeric NOT NULL,
    potassium_limit_mg numeric NOT NULL,
    sodium_limit_mg numeric NOT NULL,
    sugar_limit_g numeric NOT NULL,
    carb_limit_g numeric NOT NULL,
    water_limit_ml numeric NOT NULL
);

-- 2. ตารางโปรไฟล์สุขภาพของผู้ใช้ (User Health Profiles)
CREATE TABLE IF NOT EXISTS public.user_health_profiles (
    user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    ckd_stage text REFERENCES public.ckd_rules(stage),
    weight_kg numeric,
    gender text,
    custom_protein_limit_g numeric,
    custom_potassium_limit_mg numeric,
    custom_sodium_limit_mg numeric,
    custom_sugar_limit_g numeric,
    custom_carb_limit_g numeric,
    custom_water_limit_ml numeric,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- 3. ตารางสรุปโภชนาการรายวัน (Daily Logs)
CREATE TABLE IF NOT EXISTS public.daily_logs (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    log_date date NOT NULL,
    total_protein_g numeric DEFAULT 0,
    total_potassium_mg numeric DEFAULT 0,
    total_sodium_mg numeric DEFAULT 0,
    total_sugar_g numeric DEFAULT 0,
    total_carb_g numeric DEFAULT 0,
    total_water_ml numeric DEFAULT 0,
    deleted_at timestamptz,
    UNIQUE(user_id, log_date) -- 1 วันมีได้แค่ 1 สรุปต่อ 1 ผู้ใช้
);

-- 4. ตารางบันทึกมื้ออาหารย่อย (Meals)
CREATE TABLE IF NOT EXISTS public.meals (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    log_id uuid NOT NULL REFERENCES public.daily_logs(id) ON DELETE CASCADE,
    food_id text NOT NULL,
    food_name text NOT NULL,
    quantity_g numeric NOT NULL,
    meal_type text NOT NULL,
    protein_g numeric DEFAULT 0,
    potassium_mg numeric DEFAULT 0,
    sodium_mg numeric DEFAULT 0,
    sugar_g numeric DEFAULT 0,
    carb_g numeric DEFAULT 0,
    water_ml numeric DEFAULT 0,
    created_at timestamptz DEFAULT now(),
    deleted_at timestamptz
);

-- ==============================================================================
-- Function RPC สำหรับเพิ่มมื้ออาหาร (Log Meal)
-- ==============================================================================
CREATE OR REPLACE FUNCTION log_meal(
    p_food_id text,
    p_food_name text,
    p_quantity_g numeric,
    p_meal_type text,
    p_protein numeric,
    p_potassium numeric,
    p_sodium numeric,
    p_sugar numeric,
    p_carb numeric,
    p_water numeric
) RETURNS void AS $$
DECLARE
    v_user_id uuid;
    v_log_id uuid;
    v_today date := (now() AT TIME ZONE 'Asia/Bangkok')::date;
BEGIN
    -- ดึง user_id จากคนที่ Login ปัจจุบัน (ความปลอดภัยสูง)
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- ค้นหาหรือสร้าง Daily Log ของวันนี้
    SELECT id INTO v_log_id FROM public.daily_logs 
    WHERE user_id = v_user_id AND log_date = v_today;

    IF NOT FOUND THEN
        INSERT INTO public.daily_logs (user_id, log_date)
        VALUES (v_user_id, v_today)
        RETURNING id INTO v_log_id;
    END IF;

    -- เพิ่มมื้ออาหาร
    INSERT INTO public.meals (
        log_id, food_id, food_name, quantity_g, meal_type, 
        protein_g, potassium_mg, sodium_mg, sugar_g, carb_g, water_ml
    ) VALUES (
        v_log_id, p_food_id, p_food_name, p_quantity_g, p_meal_type,
        p_protein, p_potassium, p_sodium, p_sugar, p_carb, p_water
    );

    -- อัปเดตยอดรวมในตาราง Daily Log
    UPDATE public.daily_logs
    SET 
        total_protein_g = total_protein_g + p_protein,
        total_potassium_mg = total_potassium_mg + p_potassium,
        total_sodium_mg = total_sodium_mg + p_sodium,
        total_sugar_g = total_sugar_g + p_sugar,
        total_carb_g = total_carb_g + p_carb,
        total_water_ml = total_water_ml + p_water
    WHERE id = v_log_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
