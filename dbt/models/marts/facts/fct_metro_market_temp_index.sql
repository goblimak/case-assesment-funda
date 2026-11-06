select
    region_id,
    month_date,
    market_temp_index
from {{ ref('stg_metro_market_temp_index') }}
