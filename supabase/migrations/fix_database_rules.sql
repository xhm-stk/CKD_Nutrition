-- 1. เพิ่มข้อมูลกฎโภชนาการสำหรับโรคไตแต่ละระยะ (Master Data)
-- สาเหตุที่เซฟโปรไฟล์ไม่ได้ เพราะตารางนี้อาจจะยังว่างเปล่า ทำให้เกิด Foreign Key Error ครับ
INSERT INTO public.ckd_rules (stage, protein_limit_g, potassium_limit_mg, sodium_limit_mg, sugar_limit_g, carb_limit_g, water_limit_ml) 
VALUES
('stage_1', 0.8, 2000, 2000, 24, 300, 2000),
('stage_2', 0.8, 2000, 2000, 24, 300, 2000),
('stage_3a', 0.6, 1500, 2000, 24, 250, 1500),
('stage_3b', 0.6, 1500, 2000, 24, 250, 1500),
('stage_4', 0.6, 1500, 2000, 24, 200, 1000),
('stage_5', 1.2, 2000, 2000, 24, 250, 1000)
ON CONFLICT (stage) DO NOTHING;

-- 2. อนุญาตให้ผู้ใช้อ่านข้อมูลกฎโภชนาการได้ทุกคน (เพื่อให้แอปดึงไปคำนวณได้)
ALTER TABLE public.ckd_rules ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow everyone to read ckd_rules" ON public.ckd_rules;
CREATE POLICY "Allow everyone to read ckd_rules" ON public.ckd_rules FOR SELECT USING (true);

-- 3. ตั้งค่าระบบรักษาความปลอดภัย (RLS) ให้ตารางโปรไฟล์สุขภาพ
-- อนุญาตให้ผู้ใช้แต่ละคน สามารถเพิ่ม (Insert), แก้ไข (Update) และอ่าน (Select) ข้อมูลของตัวเองได้เท่านั้น
ALTER TABLE public.user_health_profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own profile" ON public.user_health_profiles;
CREATE POLICY "Users can read own profile" ON public.user_health_profiles 
FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own profile" ON public.user_health_profiles;
CREATE POLICY "Users can insert own profile" ON public.user_health_profiles 
FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.user_health_profiles;
CREATE POLICY "Users can update own profile" ON public.user_health_profiles 
FOR UPDATE USING (auth.uid() = user_id);
