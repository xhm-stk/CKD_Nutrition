-- ==============================================================================
-- SQL Migration: แก้ไขและอุดรอยรั่วความสัมพันธ์ Foreign Key (PGRST200 Fix)
-- วิธีใช้: นำสคริปต์นี้ไปรันในช่อง SQL Editor บนหน้าเว็บ Dashboard ของ Supabase
-- ==============================================================================

-- 1. ลบ Foreign Key เก่าออกก่อนหากชื่อชนกัน (เพื่อป้องกันความซ้ำซ้อน)
ALTER TABLE public.user_health_profiles
DROP CONSTRAINT IF EXISTS fk_user_health_profiles_ckd_rules;

-- 2. สร้าง Foreign Key เชื่อมโยง ckd_stage ใน user_health_profiles ไปยัง stage ใน ckd_rules
ALTER TABLE public.user_health_profiles
ADD CONSTRAINT fk_user_health_profiles_ckd_rules
FOREIGN KEY (ckd_stage) 
REFERENCES public.ckd_rules(stage)
ON UPDATE CASCADE
ON DELETE SET NULL;

-- 3. สั่งรีโหลด API Schema Cache ของ Supabase (Postgrest) ทันที
-- เพื่อให้ API มองเห็นความสัมพันธ์ Foreign Key ล่าสุดที่เพิ่งผูกมัดไป
NOTIFY pgrst, 'reload schema';
