{{
    config(
        tags=["customers"]
    )
}}


SELECT
    *,
    CURRENT_DATE AS load_date 
FROM {{ source('car_ops', 'customers') }}
