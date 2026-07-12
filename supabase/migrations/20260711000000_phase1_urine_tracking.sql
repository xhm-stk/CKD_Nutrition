-- ==============================================================================
-- 🔧 CKD Nutrition App: Phase 1 Urine Tracking Migration
-- วันที่: 2026-07-11
-- ==============================================================================

-- 1. เพิ่ม column total_urine_ml ใน daily_logs
ALTER TABLE public.daily_logs
  ADD COLUMN IF NOT EXISTS total_urine_ml DECIMAL(6,1) NOT NULL DEFAULT 0.0;

-- 2. สร้างตาราง urine_logs
CREATE TABLE IF NOT EXISTS public.urine_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  log_id UUID REFERENCES public.daily_logs(id) ON DELETE CASCADE NOT NULL,
  amount_ml DECIMAL(6,1) NOT NULL CHECK (amount_ml >= 0),
  logged_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. เปิดใช้ RLS (Row Level Security) บน urine_logs
ALTER TABLE public.urine_logs ENABLE ROW LEVEL SECURITY;

-- 4. นโยบายสิทธิ์ (RLS Policies) สำหรับ urine_logs
DROP POLICY IF EXISTS "Users can manage their own urine logs" ON public.urine_logs;
CREATE POLICY "Users can manage their own urine logs" ON public.urine_logs
  FOR ALL USING (auth.uid() = user_id);

-- 5. สร้าง ฟังก์ชัน & Trigger เพื่อคำนวณและสะสม total_urine_ml ลง daily_logs
CREATE OR REPLACE FUNCTION update_daily_urine_total()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE public.daily_logs
    SET total_urine_ml = total_urine_ml + NEW.amount_ml
    WHERE id = NEW.log_id;
    RETURN NEW;
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE public.daily_logs
    SET total_urine_ml = total_urine_ml - OLD.amount_ml + NEW.amount_ml
    WHERE id = NEW.log_id;
    RETURN NEW;
  ELSIF (TG_OP = 'DELETE') THEN
    UPDATE public.daily_logs
    SET total_urine_ml = total_urine_ml - OLD.amount_ml
    WHERE id = OLD.log_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_update_daily_urine_total ON public.urine_logs;
CREATE TRIGGER trigger_update_daily_urine_total
  AFTER INSERT OR UPDATE OR DELETE ON public.urine_logs
  FOR EACH ROW EXECUTE FUNCTION update_daily_urine_total();

-- 6. ฟังก์ชัน RPC: log_urine สำหรับบันทึกปัสสาวะ
CREATE OR REPLACE FUNCTION public.log_urine(p_amount_ml numeric)
RETURNS void AS $$
DECLARE
    v_user_id uuid;
    v_log_id uuid;
    v_today date := (now() AT TIME ZONE 'Asia/Bangkok')::date;
BEGIN
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

    -- บันทึกปัสสาวะ
    INSERT INTO public.urine_logs (user_id, log_id, amount_ml)
    VALUES (v_user_id, v_log_id, p_amount_ml);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. ฟังก์ชัน RPC: delete_urine สำหรับลบข้อมูลปัสสาวะ
CREATE OR REPLACE FUNCTION public.delete_urine(p_urine_id uuid)
RETURNS void AS $$
DECLARE
    v_user_id uuid;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    DELETE FROM public.urine_logs
    WHERE id = p_urine_id AND user_id = v_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 8. อัปเดตโครงสร้าง dashboard_summary View
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
  dl.total_urine_ml, -- ✅ ดึงตัวเลขปัสสาวะ

  -- ข้อมูลสุขภาพผู้ใช้
  hp.ckd_stage,
  hp.weight_kg,
  hp.gender,

  -- Limits จาก ckd_rules (Dynamic: ใช้ค่าจาก table ที่ถูกต้องตาม stage)
  cr.protein_limit_g,
  cr.potassium_limit_mg,
  cr.sodium_limit_mg,
  cr.sugar_limit_g,
  cr.carb_limit_g,
  cr.water_limit_ml,
  cr.protein_multiplier
FROM public.daily_logs dl
JOIN public.user_health_profiles hp
  ON dl.user_id = hp.user_id
JOIN public.ckd_rules cr
  ON hp.ckd_stage = cr.stage
WHERE dl.deleted_at IS NULL;
