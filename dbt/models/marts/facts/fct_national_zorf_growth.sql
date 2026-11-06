select
    region_id,
    month_date,
    zorf_growth_pct
from {{ ref('stg_national_zorf_growth') }}
