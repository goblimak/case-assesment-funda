select
    region_id,
    month_date,
    inventory_count
from {{ ref('stg_metro_inventory') }}
