{% snapshot slv_subscriptions_snap %}
    {{
        config(
            unique_key='subscription_id',
            strategy='check',
            check_cols=['customer_id', 'car_id', 'term_months', 'created_at', 'start_date', 'end_date', 'start_month', 'start_week', 'monthly_rate', 'is_active'],
            tags=['scd', 'subscriptions'],
            hard_deletes='invalidate'
        )
    }}

    -- Capture subscription changes over time (especially status and date changes)
    SELECT
        subscription_id,
        customer_id,
        car_id,
        term_months,
        created_at,
        start_date,  -- May change if subscription is rescheduled
        end_date,  -- Calculated field based on start_date + term
        start_month,
        start_week,
        monthly_rate,  -- May change due to pricing updates
        is_active,  -- Status flag that changes as subscriptions start/end
        rep_date AS slv_rep_date,  -- Original reporting date from silver layer
        CURRENT_DATE AS snapshot_date  -- When this snapshot was taken
    FROM {{ ref('slv_subscriptions') }}

{% endsnapshot %}