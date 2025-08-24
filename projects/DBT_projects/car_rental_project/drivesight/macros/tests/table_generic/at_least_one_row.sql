{% test at_least_one_row(model) %}

SELECT 1
WHERE NOT EXISTS (
    SELECT 1
    FROM {{ model }}
)

{% endtest %}