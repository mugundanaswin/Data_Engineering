{{
    config(
        tags=["cars"]
    )
}}

SELECT
    *,
    CURRENT_DATE AS load_date
FROM {{ source('car_ops', 'cars') }}
