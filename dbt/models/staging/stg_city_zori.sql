{% set source_relation = source('raw', 'city_zori_uc_sfrcondomfr_sm_month') %}
{% set date_columns = get_unpivot_date_columns(source_relation, ['regionid', 'regionname', 'regiontype', 'statename', 'state', 'metro', 'countyname', 'sizerank']) %}

select
    regionid as region_id,
    regionname as region_name,
    regiontype as region_type,
    statename as state_name,
    state as state_code,
    cast(null as varchar) as city,
    metro,
    countyname as county_name,
    cast(month_date as date) as month_date,
    zori_index
from {{ source_relation }}
unpivot (
    zori_index for month_date in ({{ date_columns | join(', ') }})
)
where month_date is not null
