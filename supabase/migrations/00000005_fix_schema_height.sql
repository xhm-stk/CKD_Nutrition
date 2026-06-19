-- เพิ่มคอลัมน์ height_cm (ส่วนสูง) ที่ตกหล่นไปจากฐานข้อมูล
ALTER TABLE public.user_health_profiles ADD COLUMN IF NOT EXISTS height_cm numeric;
