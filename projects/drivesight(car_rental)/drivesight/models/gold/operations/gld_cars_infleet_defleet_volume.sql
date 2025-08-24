{{
    config(
        tags=["daily_refresh", "gld_cars_infleet_defleet_volume"],
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='date',
        partition_by=["date"]
    )
}}

{% set rep_date = "'"~ validate_rep_date() ~"'::date" %}

WITH infleeted AS (
    -- Count cars registered (added to fleet) by date
    SELECT
        registration_date AS date,
        COUNT(DISTINCT car_id) AS infleeted_count
    FROM {{ ref('slv_cars') }}
{% if is_incremental() %}
    WHERE registration_date = {{ rep_date }}  -- Incremental: only yesterday's absolute data
{% else %}
    WHERE registration_date <= {{ rep_date }}  -- Full refresh: all historical data
{% endif %}
    GROUP BY registration_date
),

defleeted AS (
    -- Count cars deregistered (removed from fleet) by date
    SELECT
        deregistration_date AS date,
        COUNT(DISTINCT car_id) AS defleeted_count
    FROM {{ ref('slv_cars') }} AS cars
{% if is_incremental() %}
    WHERE deregistration_date = {{ rep_date }}  -- Incremental: only yesterday's data
{% else %}
    WHERE deregistration_date <= {{ rep_date }}  -- Full refresh: all historical data
{% endif %}
    GROUP BY deregistration_date
),

{% if is_incremental() %}
date_spine AS (
    -- For incremental runs, only process yesterday's date
    SELECT {{ rep_date }} AS date
),
{% else %}
date_spine AS (
    -- For full refresh, generate all dates from first registration to yesterday
    SELECT date
    FROM GENERATE_SERIES(
        (SELECT MIN(date) FROM infleeted),
        {{ rep_date }},
        INTERVAL 1 DAY
    ) AS t(date)
),
{% endif %}

fleet_status AS (
    -- Calculate cumulative fleet size as of each date
    SELECT
        ds.date,
        COUNT(DISTINCT sc.car_id) AS cumulative_fleet_size
    FROM {{ ref('slv_cars') }} sc
    JOIN date_spine ds 
        ON sc.registration_date <= ds.date
    AND (sc.deregistration_date IS NULL OR sc.deregistration_date > ds.date)
    GROUP BY ds.date
)

SELECT
    TRY(ds.date::DATE) AS date,
    COALESCE(i.infleeted_count, 0) AS infleeted_count,  -- Default to 0 if no cars added
    COALESCE(d.defleeted_count, 0) AS defleeted_count,  -- Default to 0 if no cars removed
    COALESCE(fs.cumulative_fleet_size, 0) AS cumulative_fleet_size,
    COALESCE(i.infleeted_count, 0) - COALESCE(d.defleeted_count, 0) AS net_fleet_change,
    CURRENT_DATE AS load_date
FROM date_spine AS ds
LEFT JOIN infleeted AS i
    ON ds.date = i.date
LEFT JOIN defleeted AS d
    ON ds.date = d.date
LEFT JOIN fleet_status AS fs
    ON ds.date = fs.date
ORDER BY ds.date DESC