{{
    config(
        tags=["cars", "daily_refresh", "weekly_refresh", "gld_cars_infleet_defleet_volume", "gld_active_customer_type_share", "gld_city_weekly_delivery_increase"]
        ,partition_by=["brand", "registration_week"]
    )
}}

{% set rep_date = validate_rep_date() %}

SELECT
    id AS car_id,
    brand,
    model,
    CASE
        WHEN LOWER(TRIM(engine_type)) IN ('electric', 'petrol', 'diesel', 'hybrid', 'gasoline')
        THEN LOWER(TRIM(engine_type))  -- Standardize known engine types
        ELSE 'other'  -- Default for unknown engine types
    END AS engine_type,
    TRY(registration_date::DATE) AS registration_date,
    TRY(deregistration_date::DATE) AS deregistration_date,
    DATEDIFF('day', registration_date, COALESCE(deregistration_date, '{{ rep_date }}'::DATE)) AS fleet_duration_days,  -- Calculate days in fleet
    CASE
        WHEN deregistration_date IS NULL THEN TRUE  -- Active if not deregistered
        ELSE FALSE
    END AS is_active,
    CURRENT_DATE AS load_date,
    '{{ rep_date }}'::DATE AS rep_date
FROM {{ ref('brz_cars') }}
WHERE load_date = '{{ rep_date }}'  -- Filter for specific reporting date as bronze layer has historical data for past reporting dates