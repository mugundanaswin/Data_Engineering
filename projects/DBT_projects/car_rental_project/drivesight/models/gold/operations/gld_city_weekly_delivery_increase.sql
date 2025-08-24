{{
    config(
        tags=["weekly_refresh", "gld_city_weekly_delivery_increase"],
        materialized='incremental',
        incremental_strategy='delete+insert',
        partition_by=["delivery_week"]
    )
}}

{% set rep_date = validate_rep_date() %}
{% set rep_week = "date_trunc('week', '" ~ rep_date ~ "'::date)" %}

-- Scheduled to run weekly, considering yesterday as last day of the week

WITH weekly_deliveries_by_city AS (
    -- Count car deliveries by city and week
    SELECT
        cust.city,
        subs.start_week,
        COUNT(cars.car_id) AS weekly_deliveries
    FROM {{ ref('slv_subscriptions') }} AS subs
    JOIN {{ ref('slv_cars') }} AS cars
        ON subs.car_id = cars.car_id
    JOIN {{ ref('slv_customers') }} AS cust
        ON subs.customer_id = cust.customer_id
{% if is_incremental() %}
    WHERE subs.start_week = {{ rep_week }}  -- Incremental: only current week
{% else %}
    WHERE subs.start_week <= {{ rep_week }}  -- Full refresh: all historical weeks
{% endif %}
    GROUP BY 1, 2
),

delivery_growth_analysis AS (
    -- Calculate week-over-week delivery growth for each city
    SELECT
        city,
        start_week,
        weekly_deliveries,
        LAG(weekly_deliveries) OVER (
            PARTITION BY city
            ORDER BY start_week
        ) AS previous_week_deliveries,  -- Previous week's deliveries for same city
        (
            weekly_deliveries - LAG(weekly_deliveries) OVER (
                PARTITION BY city
                ORDER BY start_week
            )
        ) AS deliveries_diff  -- Week-over-week change
    FROM weekly_deliveries_by_city
),

delivery_with_metrics AS (
    SELECT
        city,
        start_week,
        weekly_deliveries,
        previous_week_deliveries,
        deliveries_diff,
        -- Calculate percentage growth, handle divide-by-zero
        CASE 
            WHEN (previous_week_deliveries IS NULL OR previous_week_deliveries = 0) AND weekly_deliveries > 0 THEN 100 * weekly_deliveries
            WHEN (previous_week_deliveries IS NULL OR previous_week_deliveries = 0) AND (weekly_deliveries = 0 OR weekly_deliveries IS NULL) THEN 0
            ELSE ROUND(100 * deliveries_diff / previous_week_deliveries, 2)
        END AS growth_rate,
        -- Rank cities by weekly deliveries descending
        RANK() OVER (PARTITION BY start_week ORDER BY weekly_deliveries DESC) AS delivery_rank
    FROM delivery_growth_analysis
)

SELECT
    city,
    start_week AS delivery_week,
    weekly_deliveries AS current_week_deliveries,
    previous_week_deliveries,
    deliveries_diff,
    growth_rate,
    delivery_rank,
    CURRENT_DATE AS load_date
FROM delivery_with_metrics dwm
WHERE deliveries_diff = (
    -- Only return cities with maximum growth for each week
    SELECT MAX(deliveries_diff)
    FROM delivery_growth_analysis
    WHERE start_week = dwm.start_week
)
ORDER BY delivery_week DESC, city
