-- ==============================================================================
-- SQL Migration: เพิ่มฟิลด์ id ใน View dashboard_summary (เวอร์ชันแก้ไข 42P16)
-- วิธีใช้: นำสคริปต์นี้ไปรันในช่อง SQL Editor บนหน้าเว็บ Dashboard ของ Supabase
-- ==============================================================================

-- 1. ลบ View เดิมออกก่อนด้วย CASCADE เพื่อหลีกเลี่ยงข้อจำกัดการเปลี่ยนคอลัมน์ของ PostgreSQL
DROP VIEW IF EXISTS public.dashboard_summary CASCADE;

-- 2. สร้าง View ใหม่พร้อมคอลัมน์ dl.id เพื่อส่งรหัสไอดีให้กับแอป Flutter
CREATE VIEW public.dashboard_summary AS
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

-- 3. อัปเดตสิทธิ์การเข้าถึง View ใหม่
GRANT SELECT ON public.dashboard_summary TO authenticated;
GRANT SELECT ON public.dashboard_summary TO anon;

-- 4. สั่งรีโหลด API cache ของ Supabase (Postgrest) ทันที
NOTIFY pgrst, 'reload schema';
