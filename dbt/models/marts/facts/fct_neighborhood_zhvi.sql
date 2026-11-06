select
    region_id,
    month_date,
    zhvi_value
from {{ ref('stg_neighborhood_zhvi') }}
