-- 20260612_sprint6_meal_planner.sql

-- RPC to recommend 3 random meals whose combined nutrition fits the remaining daily limits
CREATE OR REPLACE FUNCTION recommend_meals(p_user_id uuid)
RETURNS SETOF public.food_master AS $$
DECLARE
    v_limit_protein numeric;
    v_limit_potassium numeric;
    v_limit_sodium numeric;
    v_limit_sugar numeric;
    v_limit_carb numeric;
    v_limit_water numeric;

    v_today_protein numeric := 0;
    v_today_potassium numeric := 0;
    v_today_sodium numeric := 0;
    v_today_sugar numeric := 0;
    v_today_carb numeric := 0;
    v_today_water numeric := 0;

    v_rem_protein numeric;
    v_rem_potassium numeric;
    v_rem_sodium numeric;
    v_rem_sugar numeric;
    v_rem_carb numeric;
    v_rem_water numeric;
BEGIN
    -- 1. Get user limits (with fallback defaults if not found)
    SELECT 
        COALESCE(uhp.custom_protein_limit_g, (cr.protein_multiplier * uhp.weight_kg), 60),
        COALESCE(uhp.custom_potassium_limit_mg, cr.potassium_limit_mg, 2000),
        COALESCE(uhp.custom_sodium_limit_mg, cr.sodium_limit_mg, 2000),
        COALESCE(uhp.custom_sugar_limit_g, cr.sugar_limit_g, 50),
        COALESCE(uhp.custom_carb_limit_g, cr.carb_limit_g, 300),
        COALESCE(uhp.custom_water_limit_ml, cr.water_limit_ml, 1500)
    INTO 
        v_limit_protein, v_limit_potassium, v_limit_sodium, v_limit_sugar, v_limit_carb, v_limit_water
    FROM public.user_health_profiles uhp
    LEFT JOIN public.ckd_rules cr ON uhp.ckd_stage = cr.stage
    WHERE uhp.user_id = p_user_id;

    -- Fallback defaults for missing profiles
    IF v_limit_protein IS NULL THEN
        v_limit_protein := 60;
        v_limit_potassium := 2000;
        v_limit_sodium := 2000;
        v_limit_sugar := 50;
        v_limit_carb := 300;
        v_limit_water := 1500;
    END IF;

    -- 2. Get today's consumption
    SELECT 
        total_protein_g, total_potassium_mg, total_sodium_mg, total_sugar_g, total_carb_g, total_water_ml
    INTO 
        v_today_protein, v_today_potassium, v_today_sodium, v_today_sugar, v_today_carb, v_today_water
    FROM public.daily_logs
    WHERE user_id = p_user_id AND log_date = CURRENT_DATE;

    -- 3. Calculate remaining limits
    v_rem_protein := v_limit_protein - COALESCE(v_today_protein, 0);
    v_rem_potassium := v_limit_potassium - COALESCE(v_today_potassium, 0);
    v_rem_sodium := v_limit_sodium - COALESCE(v_today_sodium, 0);
    v_rem_sugar := v_limit_sugar - COALESCE(v_today_sugar, 0);
    v_rem_carb := v_limit_carb - COALESCE(v_today_carb, 0);
    v_rem_water := v_limit_water - COALESCE(v_today_water, 0);

    -- 4. Select 3 random foods where each is <= 1/3 of the remaining limit
    RETURN QUERY
    SELECT f.*
    FROM public.food_master f
    WHERE 
        f.protein_g <= v_rem_protein / 3
        AND f.potassium_mg <= v_rem_potassium / 3
        AND f.sodium_mg <= v_rem_sodium / 3
        AND f.sugar_g <= v_rem_sugar / 3
        AND f.carb_g <= v_rem_carb / 3
        AND f.water_ml <= v_rem_water / 3
    ORDER BY random()
    LIMIT 3;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
