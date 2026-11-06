{% set source_relation = source('raw', 'national_zorf_growth_uc_sfr_sm_month') %}
{% set date_columns = get_unpivot_date_columns(source_relation, ['regionid', 'regionname', 'regiontype', 'basedate', 'sizerank']) %}

select
    regionid as region_id,
    regionname as region_name,
    regiontype as region_type,
    cast(null as varchar) as state_name,
    cast(null as varchar) as state_code,
    cast(null as varchar) as city,
    cast(null as varchar) as metro,
    cast(null as varchar) as county_name,
    cast(month_date as date) as month_date,
    zorf_growth_pct
from {{ source_relation }}
unpivot (
    zorf_growth_pct for month_date in ({{ date_columns | join(', ') }})
)
where month_date is not null
