{% macro validate_rep_date() %}
    {% set rep_date = var('rep_date', none) %}
    {% set today = modules.datetime.date.today().strftime('%Y-%m-%d') %}
    {% if rep_date is none %}
        {% do log("Variable 'rep_date' not provided. Defaulting to today's date: " ~ today, info=true) %}
        {% do return(today) %}
    {% else %}
        {% set rep_date_obj = modules.datetime.datetime.strptime(rep_date, '%Y-%m-%d').date() %}
        {% if rep_date > today %}
            {% do exceptions.raise_compiler_error("Provided 'rep_date' (" ~ rep_date ~ ") cannot be in the future. Today is " ~ today ~ ".") %}
        {% else %}
            {% do return(rep_date) %}
        {% endif %}
    {% endif %}


{% endmacro %}
