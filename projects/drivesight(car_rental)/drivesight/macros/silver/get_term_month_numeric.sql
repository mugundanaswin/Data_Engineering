{% macro get_term_month_numeric(month_word) %}

    CASE LOWER(TRIM({{ month_word }}))
        WHEN 'one' THEN 1
        WHEN 'two' THEN 2
        WHEN 'three' THEN 3
        WHEN 'four' THEN 4
        WHEN 'five' THEN 5
        WHEN 'six' THEN 6
        WHEN 'seven' THEN 7
        WHEN 'eight' THEN 8
        WHEN 'nine' THEN 9
        WHEN 'ten' THEN 10
        WHEN 'eleven' THEN 11
        WHEN 'twelve' THEN 12
        ELSE -1  -- Flag for unexpected/invalid values
    END
{% endmacro %}
