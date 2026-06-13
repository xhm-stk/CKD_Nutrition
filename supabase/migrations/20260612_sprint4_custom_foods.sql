-- 20260612_sprint4_custom_foods.sql

-- 1. Table for Food Master (Centralized food database)
CREATE TABLE IF NOT EXISTS public.food_master (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    calories numeric DEFAULT 0,
    protein_g numeric DEFAULT 0,
    potassium_mg numeric DEFAULT 0,
    sodium_mg numeric DEFAULT 0,
    sugar_g numeric DEFAULT 0,
    carb_g numeric DEFAULT 0,
    water_ml numeric DEFAULT 0,
    serving_size_g numeric DEFAULT 100,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- 2. Table for Custom Foods (User-specific food entries)
CREATE TABLE IF NOT EXISTS public.custom_foods (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name text NOT NULL,
    calories numeric DEFAULT 0,
    protein_g numeric DEFAULT 0,
    potassium_mg numeric DEFAULT 0,
    sodium_mg numeric DEFAULT 0,
    sugar_g numeric DEFAULT 0,
    carb_g numeric DEFAULT 0,
    water_ml numeric DEFAULT 0,
    serving_size_g numeric DEFAULT 100,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- 3. Row Level Security (RLS) for Custom Foods
ALTER TABLE public.custom_foods ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own custom foods"
    ON public.custom_foods
    FOR ALL
    USING (auth.uid() = user_id);
