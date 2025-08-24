{{
    config(
        tags=["daily_refresh", "gld_active_customer_type_share"],
        materialized='incremental',
        incremental_strategy='delete+insert',
        partition_by=["month", "brand", "customer_type"]
    )
}}

{% set rep_date = validate_rep_date() %}
{% set rep_month = "date_trunc('month', '" ~ rep_date ~ "'::date)" %}

WITH customer_type_by_brand AS (
    -- Count active customers by type and brand for each month
    SELECT
        subs.start_month,
        cars.brand,
        cust.customer_type,
        COUNT(DISTINCT subs.customer_id) AS active_customers_per_type_car_brand_month,
        COUNT(DISTINCT subs.car_id) AS num_cars_used,
        AVG(subs.term_months) AS avg_term_months
    FROM {{ ref('slv_subscriptions') }} AS subs
    JOIN {{ ref('slv_cars') }} AS cars
        ON subs.car_id = cars.car_id
    JOIN {{ ref('slv_customers') }} AS cust
        ON subs.customer_id = cust.customer_id
    WHERE 1 = 1
        AND subs.is_active = TRUE  -- Only active subscriptions
        AND cars.is_active = TRUE  -- Only active cars
{% if is_incremental() %}
        AND subs.start_month = {{ rep_month }}  -- Incremental: only current month
{% else %}
        AND subs.start_month <= {{ rep_month }}  -- Full refresh: all historical data
{% endif %}
    GROUP BY 1, 2, 3
),

brand_totals AS (
    -- Calculate total customers per brand/month for percentage calculation
    SELECT
        start_month,
        brand,
        SUM(active_customers_per_type_car_brand_month) AS active_customers_per_car_brand_month
    FROM customer_type_by_brand
    GROUP BY 1, 2
)

SELECT
    ctb.start_month AS month,
    ctb.brand,
    ctb.customer_type,
    ctb.active_customers_per_type_car_brand_month,
    bt.active_customers_per_car_brand_month,
    ROUND(
        ctb.active_customers_per_type_car_brand_month / bt.active_customers_per_car_brand_month,
        4
    ) AS customer_type_share,  -- Calculate percentage share of each customer type
    ctb.num_cars_used,
    ctb.avg_term_months,
    CURRENT_DATE AS load_date
FROM customer_type_by_brand AS ctb
JOIN brand_totals AS bt
    ON ctb.start_month = bt.start_month
    AND ctb.brand = bt.brand
ORDER BY ctb.start_month, ctb.brand, ctb.customer_type