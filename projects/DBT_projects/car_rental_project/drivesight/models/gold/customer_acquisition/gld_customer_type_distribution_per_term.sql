{{
    config(
        tags=["daily_refresh", "gla_customer_type_distribution_per_term"],
        materialized='table',
        partition_by=["term_months", "customer_type"]
    )
}}

WITH customer_type_by_term AS (
    -- Count customers by type for each subscription term length
    SELECT
        subs.term_months,
        cust.customer_type,
        COUNT(DISTINCT subs.customer_id) AS customers_per_type_term,
        COUNT(subs.subscription_id) AS subscriptions_per_type_term,
        AVG(subs.monthly_rate) AS avg_monthly_rate_per_type_term,
        SUM(subs.term_months * subs.monthly_rate) AS total_revenue_per_type_term
    FROM {{ ref('slv_subscriptions') }} AS subs
    JOIN {{ ref('slv_customers') }} AS cust
        ON subs.customer_id = cust.customer_id
    GROUP BY 1, 2
),

term_totals AS (
    -- Calculate total customers per term for percentage calculation
    SELECT
        term_months,
        SUM(customers_per_type_term) AS customers_per_term
    FROM customer_type_by_term
    GROUP BY 1
)

SELECT
    ctt.term_months,
    ctt.customer_type,
    ctt.customers_per_type_term,
    ctt.subscriptions_per_type_term,
    ctt.avg_monthly_rate_per_type_term,
    ctt.total_revenue_per_type_term,
    tt.customers_per_term,
    ROUND(
        TRY(ctt.customers_per_type_term::DECIMAL) / tt.customers_per_term, 4
    ) AS customer_type_share,  -- Calculate percentage share of each customer type per term
    CURRENT_DATE AS load_date
FROM customer_type_by_term AS ctt
JOIN term_totals AS tt
    ON ctt.term_months = tt.term_months
ORDER BY ctt.term_months, ctt.customer_type