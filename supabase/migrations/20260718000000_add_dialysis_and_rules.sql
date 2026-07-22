-- ==============================================================================
-- 🔧 CKD Nutrition App: Add Dialysis Status & Update CKD Rules Migration
-- วันที่: 2026-07-18
-- ==============================================================================

-- 1. เพิ่มคอลัมน์ is_on_dialysis ในตาราง user_health_profiles
ALTER TABLE public.user_health_profiles
  ADD COLUMN IF NOT EXISTS is_on_dialysis boolean NOT NULL DEFAULT false;

-- 2. ปรับปรุงข้อมูลมาสเตอร์ในตาราง ckd_rules ด้วยค่าใหม่ที่ทำความสะอาดเรียบร้อยแล้ว
INSERT INTO public.ckd_rules (stage, protein_limit_g, potassium_limit_mg, sodium_limit_mg, sugar_limit_g, carb_limit_g, water_limit_ml)
VALUES
  ('stage_1', 0.8, 3500, 2000, 24, 4.5, 2000),
  ('stage_2', 0.8, 3500, 2000, 24, 4.5, 2000),
  ('stage_3a', 0.8, 3500, 2000, 24, 4.5, 2000),
  ('stage_3b', 0.6, 1500, 2000, 24, 4.5, 2000),
  ('stage_4', 0.6, 1500, 2000, 24, 4.5, -1),
  ('stage_5', 1.2, 1500, 2000, 24, 4.5, -1)
ON CONFLICT (stage) DO UPDATE
SET
  protein_limit_g = EXCLUDED.protein_limit_g,
  potassium_limit_mg = EXCLUDED.potassium_limit_mg,
  sodium_limit_mg = EXCLUDED.sodium_limit_mg,
  sugar_limit_g = EXCLUDED.sugar_limit_g,
  carb_limit_g = EXCLUDED.carb_limit_g,
  water_limit_ml = EXCLUDED.water_limit_ml;

-- 3. อัปเดตโครงสร้าง dashboard_summary View เพื่อนำคอลัมน์ cr.protein_multiplier ที่ไม่มีอยู่ออก และรวม is_on_dialysis ด้วย
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
  dl.total_urine_ml,

  -- ข้อมูลสุขภาพผู้ใช้
  hp.ckd_stage,
  hp.weight_kg,
  hp.gender,
  hp.is_on_dialysis,

  -- Limits จาก ckd_rules (Dynamic: ใช้ค่าจาก table ที่ถูกต้องตาม stage)
  cr.protein_limit_g,
  cr.potassium_limit_mg,
  cr.sodium_limit_mg,
  cr.sugar_limit_g,
  cr.carb_limit_g,
  cr.water_limit_ml
FROM public.daily_logs dl
JOIN public.user_health_profiles hp
  ON dl.user_id = hp.user_id
JOIN public.ckd_rules cr
  ON hp.ckd_stage = cr.stage
WHERE dl.deleted_at IS NULL;
