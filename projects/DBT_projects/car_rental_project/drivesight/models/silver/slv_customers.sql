{{
    config(
        tags=["customers", "daily_refresh", "weekly_refresh", "gld_active_customer_type_share", "gld_city_weekly_delivery_increase", "gla_customer_type_distribution_per_term"]
        ,partition_by=["city"]
    )
}}

{% set rep_date = validate_rep_date() %}

SELECT
    id AS customer_id,
    CASE
        WHEN LOWER(TRIM(type)) IN ('b2b', 'b2c') THEN LOWER(TRIM(type))  -- Standardize known customer types
        ELSE 'other'  -- Default for unknown/invalid types
    END AS customer_type,
    company_name,
    address_city AS city, 
    address_zip AS zip_code,
    CURRENT_DATE AS load_date,
    '{{ rep_date }}'::DATE AS rep_date
FROM {{ ref('brz_customers') }}
WHERE load_date = '{{ rep_date }}'-- Filter for specific reporting date as bronze layer has historical data for past reporting dates