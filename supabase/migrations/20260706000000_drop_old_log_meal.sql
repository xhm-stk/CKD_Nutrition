-- Drop the old log_meal function that lacks p_phosphorus and p_eaten_at to prevent function overloading ambiguity.
DROP FUNCTION IF EXISTS public.log_meal(text, text, numeric, text, numeric, numeric, numeric, numeric, numeric, numeric);
