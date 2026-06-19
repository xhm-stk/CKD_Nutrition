-- ==============================================================================
-- Migration for Sprint 3: Dashboard Summary View
-- คำสั่งสำหรับสร้าง View เพื่อใช้ดึงข้อมูล Dashboard ใน 1 Query
-- ==============================================================================

CREATE OR REPLACE VIEW public.dashboard_summary AS
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
  uhp.ckd_stage,
  uhp.weight_kg,
  uhp.gender,
  cr.protein_limit_g,
  cr.potassium_limit_mg,
  cr.sodium_limit_mg,
  cr.sugar_limit_g,
  cr.carb_limit_g,
  cr.water_limit_ml
FROM public.daily_logs dl
JOIN public.user_health_profiles uhp ON dl.user_id = uhp.user_id
JOIN public.ckd_rules cr ON uhp.ckd_stage = cr.stage
WHERE dl.deleted_at IS NULL;

-- อย่าลืมอัปเดตสิทธิ์ให้สามารถเรียกดู View ได้
GRANT SELECT ON public.dashboard_summary TO authenticated;
GRANT SELECT ON public.dashboard_summary TO anon;
