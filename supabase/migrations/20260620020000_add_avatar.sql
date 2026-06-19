-- 20260620020000_add_avatar.sql
-- Add avatar_id to user_health_profiles to support Profile Page

ALTER TABLE public.user_health_profiles 
ADD COLUMN IF NOT EXISTS avatar_id integer DEFAULT 1;

NOTIFY pgrst, 'reload schema';
