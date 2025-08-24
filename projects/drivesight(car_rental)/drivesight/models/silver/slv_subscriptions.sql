{{
    config(
        tags=["subscriptions", "daily_refresh", "weekly_refresh", "gld_active_customer_type_share", "gld_city_weekly_delivery_increase", "gld_customer_type_distribution_per_term"]
        ,partition_by=["term_months"]
    )
}}

{% set rep_date = validate_rep_date() %}

WITH term_conversion AS (
    -- Convert text-based term months to numeric values
    SELECT
        id AS subscription_id,
        {{ get_term_month_numeric('term_month') }} AS term_months  -- Use macro to convert words to numbers
    FROM {{ ref('brz_subscriptions') }} AS brz_subs
)

SELECT
    tc.subscription_id,
    subs.customer_id,
    subs.car_id,
    tc.term_months,
    subs.created_at,
    subs.start_date,
    subs.start_date + INTERVAL (tc.term_months || ' months') AS end_date,  -- Calculate subscription end date
    DATE_TRUNC('month', subs.start_date) AS start_month,  -- Extract month for aggregations
    DATE_TRUNC('week', subs.start_date) AS start_week,  -- Extract week for aggregations
    TRY(subs.monthly_rate::DECIMAL(10, 2)) AS monthly_rate,
    CASE
        WHEN subs.start_date <= '{{ rep_date }}'
        AND subs.start_date + INTERVAL (tc.term_months || ' months') > '{{ rep_date }}'
        THEN TRUE  -- Active if subscription spans the reporting date
        ELSE FALSE
    END AS is_active,
    CURRENT_DATE AS load_date,
    '{{ rep_date }}'::DATE AS rep_date
FROM {{ ref('brz_subscriptions') }} AS subs
JOIN term_conversion AS tc
    ON subs.id = tc.subscription_id
WHERE subs.load_date = '{{ rep_date }}'-- Filter for specific reporting date as bronze layer has historical data for past reporting dates