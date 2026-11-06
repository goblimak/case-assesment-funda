select
    region_id,
    month_date,
    zori_index
from {{ ref('stg_city_zori') }}
