{% macro get_unpivot_date_columns(relation, exclude_columns=[]) %}
    {% set columns = dbt_utils.get_filtered_columns_in_relation(from=relation, except=exclude_columns) %}
    {% set date_columns = [] %}

    {% for col in columns %}
        {% if col.name | length == 10 and col.name[4:5] == '-' and col.name[7:8] == '-' %}
            {% do date_columns.append('"' ~ col.name ~ '"') %}
        {% endif %}
    {% endfor %}

    {{ return(date_columns) }}
{% endmacro %}
