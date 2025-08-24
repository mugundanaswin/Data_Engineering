{{
    config(
        tags=["subscriptions"]
    )
}}

SELECT
    *,
    CURRENT_DATE AS load_date
FROM {{ source('car_ops', 'subscriptions') }}
