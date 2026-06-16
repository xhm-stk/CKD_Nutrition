-- ============================================================
-- 🔐 Delete Account RPC (Apple Store Requirement)
-- ============================================================
-- หน้าที่: ลบบัญชีผู้ใช้และข้อมูลทั้งหมดที่ผูกกับผู้ใช้นั้นทิ้งถาวร
-- สำคัญ: ต้องใช้ SECURITY DEFINER เพื่อให้ฟังก์ชันมีสิทธิ์กระโดดเข้าไป
-- ลบข้อมูลใน Schema `auth.users` ของ Supabase ได้
-- ============================================================

CREATE OR REPLACE FUNCTION public.delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
DECLARE
    v_user_id uuid;
BEGIN
    -- ดึง ID ของคนที่เรียกใช้งานฟังก์ชันนี้ (ป้องกันการส่ง ID คนอื่นมาลบ)
    v_user_id := auth.uid();
    
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- 1. กวาดล้างข้อมูลส่วนตัวใน Public Schema ก่อน (เผื่อไม่ได้ตั้ง CASCADE ไว้)
    DELETE FROM public.daily_logs WHERE user_id = v_user_id;
    DELETE FROM public.user_health_profiles WHERE user_id = v_user_id;
    DELETE FROM public.custom_foods WHERE user_id = v_user_id;
    -- (ตารางอาหารในเครื่อง food_master ไม่เกี่ยว เพราะเป็นแคตตาล็อกกลาง)

    -- 2. ลบบัญชีผู้ใช้ออกระบบยืนยันตัวตน (Supabase Auth)
    -- ขั้นตอนนี้จะเตะผู้ใช้ออกจากระบบ และทำให้ล็อกอินด้วยอีเมล/Apple ID เดิมไม่ได้อีกจนกว่าจะสมัครใหม่
    DELETE FROM auth.users WHERE id = v_user_id;
END;
$$;
