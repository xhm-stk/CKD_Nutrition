-- Add full_name, age, and egfr columns to user_health_profiles table
ALTER TABLE public.user_health_profiles 
  ADD COLUMN IF NOT EXISTS full_name text,
  ADD COLUMN IF NOT EXISTS age integer,
  ADD COLUMN IF NOT EXISTS egfr numeric;
