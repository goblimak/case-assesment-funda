with date_spine as (
    {{
        dbt_utils.date_spine(
            datepart='month',
            start_date="cast('2020-01-01' as date)",
            end_date="cast('2030-12-01' as date)"
        )
    }}
)

select
    cast(date_month as date) as month_date,
    date_trunc('month', date_month)::date as month_start_date,
    extract(year from date_month) as year_number,
    extract(month from date_month) as month_number,
    monthname(date_month) as month_name,
    strftime(date_month, '%Y-%m') as year_month
from date_spine
order by month_date
