select
    region_id,
    month_date,
    new_construction_sales_count
from {{ ref('stg_metro_new_con_sales_count') }}
