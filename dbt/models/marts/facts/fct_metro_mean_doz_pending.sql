select
    region_id,
    month_date,
    mean_days_on_market
from {{ ref('stg_metro_mean_doz_pending') }}
