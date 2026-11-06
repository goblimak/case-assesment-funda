select
    region_id,
    month_date,
    income_needed_for_downpayment
from {{ ref('stg_metro_new_homeowner_income_needed_downpayment') }}
