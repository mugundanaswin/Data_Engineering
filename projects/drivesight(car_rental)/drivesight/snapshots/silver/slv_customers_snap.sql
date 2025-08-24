{% snapshot slv_customers_snap %}
    {{
        config(
            unique_key='customer_id',
            strategy='check',
            check_cols=['customer_type', 'company_name', 'city', 'zip_code'],
            tags=['scd', 'customers'],
            hard_deletes='invalidate'
        )
    }}

    -- Capture customer dimension changes over time
    SELECT
        customer_id,
        customer_type,
        company_name,
        city,
        zip_code,
        rep_date AS slv_rep_date,  -- Original reporting date from silver layer
        CURRENT_DATE AS snapshot_date  -- When this snapshot was taken
    FROM {{ ref('slv_customers') }}

{% endsnapshot %}