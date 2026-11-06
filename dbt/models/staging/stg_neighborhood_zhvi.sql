{% set source_relation = source('raw', 'neighborhood_zhvi_uc_sfrcondo_tier') %}
{% set date_columns = get_unpivot_date_columns(source_relation, ['regionid', 'regionname', 'regiontype', 'statename', 'state', 'city', 'metro', 'countyname', 'sizerank']) %}

select
    regionid as region_id,
    regionname as region_name,
    regiontype as region_type,
    statename as state_name,
    state as state_code,
    city,
    metro,
    countyname as county_name,
    cast(month_date as date) as month_date,
    zhvi_value
from {{ source_relation }}
unpivot (
    zhvi_value for month_date in ({{ date_columns | join(', ') }})
)
where month_date is not null
