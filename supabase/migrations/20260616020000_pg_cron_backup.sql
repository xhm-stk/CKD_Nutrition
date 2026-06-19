-- ============================================================
-- ☁️ Automated Database Backup (Supabase pg_cron)
-- ============================================================
-- หน้าที่: สคริปต์นี้จะตั้งเวลา (Cron Job) ให้ฐานข้อมูลทำการ
-- สำรองข้อมูลตารางที่สำคัญ (daily_logs, user_health_profiles)
-- เอาไปเก็บไว้ใน Schema 'backups' ทุกๆ เที่ยงคืน เพื่อป้องกันข้อมูลสูญหาย
-- ============================================================

-- 1. เปิดใช้งาน Extension pg_cron (ถ้ายังไม่ได้เปิด)
CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA extensions;

-- 2. สร้าง Schema สำหรับเก็บข้อมูล Backup โดยเฉพาะ ป้องกันไม่ให้ปนกับข้อมูลจริง
CREATE SCHEMA IF NOT EXISTS backups;

-- 3. สร้างฟังก์ชันสำหรับการแบ็คอัปข้อมูล
CREATE OR REPLACE FUNCTION public.backup_critical_data()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    backup_table_name text;
BEGIN
    -- สร้างชื่อตารางแบ็คอัปตามวันที่ เช่น daily_logs_20260616
    backup_table_name := 'backups.daily_logs_' || to_char(now(), 'YYYYMMDD');
    
    -- ก๊อปปี้ตาราง daily_logs ทั้งหมดไปเก็บไว้
    EXECUTE format('CREATE TABLE IF NOT EXISTS %s AS SELECT * FROM public.daily_logs', backup_table_name);

    -- สร้างชื่อตารางแบ็คอัปสำหรับ profiles
    backup_table_name := 'backups.user_profiles_' || to_char(now(), 'YYYYMMDD');
    
    -- ก๊อปปี้ตาราง user_health_profiles ทั้งหมดไปเก็บไว้
    EXECUTE format('CREATE TABLE IF NOT EXISTS %s AS SELECT * FROM public.user_health_profiles', backup_table_name);

    -- 5. ลบตารางแบ็คอัปที่เก่าเกิน 30 วัน (Retention Policy) เพื่อประหยัดพื้นที่
    FOR backup_table_name IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'backups' 
          AND table_name ~ '^(daily_logs_|user_profiles_)[0-9]{8}$'
          AND to_date(substring(table_name from '[0-9]{8}$'), 'YYYYMMDD') < now() - interval '30 days'
    LOOP
        EXECUTE format('DROP TABLE backups.%I', backup_table_name);
    END LOOP;
END;
$$;

-- 4. ตั้งเวลา Cron Job (รันทุกๆ เที่ยงคืน 00:00 ของทุกวัน)
-- รหัส '0 0 * * *' คือมาตรฐาน Cron Expression หมายถึง เที่ยงคืนตรง
SELECT cron.schedule(
  'daily_critical_data_backup', -- ชื่อ Job
  '0 0 * * *',                  -- เวลาที่รัน
  'SELECT public.backup_critical_data();' -- คำสั่งที่ให้รัน
);
