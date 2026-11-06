{% set source_relation = source('raw', 'metro_new_con_sales_count_raw_uc_sfrcondo_month') %}
{% set date_columns = get_unpivot_date_columns(source_relation, ['regionid', 'regionname', 'regiontype', 'statename', 'sizerank']) %}

select
    regionid as region_id,
    regionname as region_name,
    regiontype as region_type,
    statename as state_name,
    cast(null as varchar) as state_code,
    cast(null as varchar) as city,
    cast(null as varchar) as metro,
    cast(null as varchar) as county_name,
    cast(month_date as date) as month_date,
    new_construction_sales_count
from {{ source_relation }}
unpivot (
    new_construction_sales_count for month_date in ({{ date_columns | join(', ') }})
)
where month_date is not null
