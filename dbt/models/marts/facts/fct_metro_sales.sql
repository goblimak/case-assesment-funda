select
    region_id,
    month_date,
    monthly_sales_count
from {{ ref('stg_metro_sales_count_now') }}
