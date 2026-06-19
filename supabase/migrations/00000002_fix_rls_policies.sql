-- ==============================================================================
-- SQL Migration: เพิ่มนโยบายความปลอดภัย RLS สำหรับ daily_logs และ meals
-- วิธีใช้: นำสคริปต์นี้ไปรันในช่อง SQL Editor บนหน้าเว็บ Dashboard ของ Supabase
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. ตารางสรุปโภชนาการรายวัน (daily_logs)
-- ------------------------------------------------------------------------------
ALTER TABLE public.daily_logs ENABLE ROW LEVEL SECURITY;

-- นโยบายการดึงข้อมูล (SELECT)
DROP POLICY IF EXISTS "Users can read own daily_logs" ON public.daily_logs;
CREATE POLICY "Users can read own daily_logs" ON public.daily_logs
FOR SELECT USING (auth.uid() = user_id);

-- นโยบายการเพิ่มข้อมูล (INSERT)
DROP POLICY IF EXISTS "Users can insert own daily_logs" ON public.daily_logs;
CREATE POLICY "Users can insert own daily_logs" ON public.daily_logs
FOR INSERT WITH CHECK (auth.uid() = user_id);

-- นโยบายการแก้ไขข้อมูล (UPDATE)
DROP POLICY IF EXISTS "Users can update own daily_logs" ON public.daily_logs;
CREATE POLICY "Users can update own daily_logs" ON public.daily_logs
FOR UPDATE USING (auth.uid() = user_id);

-- นโยบายการลบข้อมูล (DELETE)
DROP POLICY IF EXISTS "Users can delete own daily_logs" ON public.daily_logs;
CREATE POLICY "Users can delete own daily_logs" ON public.daily_logs
FOR DELETE USING (auth.uid() = user_id);


-- ------------------------------------------------------------------------------
-- 2. ตารางบันทึกมื้ออาหารย่อย (meals)
-- ------------------------------------------------------------------------------
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;

-- นโยบายการดึงข้อมูล (SELECT)
DROP POLICY IF EXISTS "Users can read own meals" ON public.meals;
CREATE POLICY "Users can read own meals" ON public.meals
FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM public.daily_logs
    WHERE daily_logs.id = meals.log_id
    AND daily_logs.user_id = auth.uid()
  )
);

-- นโยบายการเพิ่มข้อมูล (INSERT)
DROP POLICY IF EXISTS "Users can insert own meals" ON public.meals;
CREATE POLICY "Users can insert own meals" ON public.meals
FOR INSERT WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.daily_logs
    WHERE daily_logs.id = meals.log_id
    AND daily_logs.user_id = auth.uid()
  )
);

-- นโยบายการแก้ไขข้อมูล (UPDATE)
DROP POLICY IF EXISTS "Users can update own meals" ON public.meals;
CREATE POLICY "Users can update own meals" ON public.meals
FOR UPDATE USING (
  EXISTS (
    SELECT 1 FROM public.daily_logs
    WHERE daily_logs.id = meals.log_id
    AND daily_logs.user_id = auth.uid()
  )
);

-- นโยบายการลบข้อมูล (DELETE)
DROP POLICY IF EXISTS "Users can delete own meals" ON public.meals;
CREATE POLICY "Users can delete own meals" ON public.meals
FOR DELETE USING (
  EXISTS (
    SELECT 1 FROM public.daily_logs
    WHERE daily_logs.id = meals.log_id
    AND daily_logs.user_id = auth.uid()
  )
);

-- ------------------------------------------------------------------------------
-- 3. สั่งรีโหลด API cache ของ Supabase (Postgrest) ทันที
-- ------------------------------------------------------------------------------
NOTIFY pgrst, 'reload schema';
