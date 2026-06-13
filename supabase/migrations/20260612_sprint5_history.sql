-- 20260612_sprint5_history.sql

-- RPC to get monthly summary of daily logs for a user
CREATE OR REPLACE FUNCTION get_monthly_summary(target_month date, target_user_id uuid)
RETURNS TABLE (
    log_date date,
    total_protein_g numeric,
    total_potassium_mg numeric,
    total_sodium_mg numeric,
    total_sugar_g numeric,
    total_carb_g numeric,
    total_water_ml numeric
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        dl.log_date,
        dl.total_protein_g,
        dl.total_potassium_mg,
        dl.total_sodium_mg,
        dl.total_sugar_g,
        dl.total_carb_g,
        dl.total_water_ml
    FROM 
        public.daily_logs dl
    WHERE 
        dl.user_id = target_user_id
        AND date_trunc('month', dl.log_date) = date_trunc('month', target_month)
    ORDER BY 
        dl.log_date ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
