{% snapshot slv_cars_snap %}
    {{
        config(
            unique_key='car_id',
            strategy='check',
            check_cols=['brand', 'model', 'engine_type', 'registration_date', 'deregistration_date', 'fleet_duration_days', 'is_active'],
            tags=['scd', 'cars'],
            hard_deletes='invalidate'
        )
    }}

    -- Capture car dimension changes over time (especially deregistration and status changes)
    SELECT
        car_id,
        brand,
        model,
        engine_type,
        registration_date,
        deregistration_date,
        fleet_duration_days,  -- Calculated field that changes daily
        is_active,  -- Status flag that changes when deregistered
        rep_date AS slv_rep_date,  -- Original reporting date from silver layer
        CURRENT_DATE AS snapshot_date  -- When this snapshot was taken
    FROM {{ ref('slv_cars') }}

{% endsnapshot %}