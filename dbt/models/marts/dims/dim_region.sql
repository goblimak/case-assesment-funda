with region_union as (
    {{
        dbt_utils.union_relations(
            relations=[
                ref('stg_city_zori'),
                ref('stg_metro_inventory'),
                ref('stg_metro_market_temp_index'),
                ref('stg_metro_mean_doz_pending'),
                ref('stg_metro_new_con_sales_count'),
                ref('stg_metro_new_homeowner_income_needed_downpayment'),
                ref('stg_metro_sales_count_now'),
                ref('stg_national_zorf_growth'),
                ref('stg_neighborhood_zhvi')
            ],
            exclude=['month_date', 'zori_index', 'inventory_count', 'market_temp_index', 'mean_days_on_market', 'new_construction_sales_count', 'income_needed_for_downpayment', 'monthly_sales_count', 'zorf_growth_pct', 'zhvi_value']
        )
    }}
),
source_regions as (
    select
        region_id,
        region_name,
        region_type,
        state_name,
        state_code,
        city,
        metro,
        county_name,
        'United States' as country_name
    from region_union
),
normalized as (
    select
        region_id,
        region_name,
        region_type,
        country_name,
        state_name,
        state_code,
        city,
        metro,
        county_name,
        case
            when region_type = 'country' then 'country'
            when region_type = 'state' then 'state'
            when region_type = 'metro' then 'metro'
            when region_type = 'city' then 'city'
            when region_type = 'neighborhood' then 'neighborhood'
            else 'unknown'
        end as region_level,
        case
            when region_type = 'country' then 'United States'
            when region_type = 'state' then coalesce(state_name, region_name)
            when region_type = 'metro' then coalesce(metro, region_name)
            when region_type = 'city' then coalesce(city, region_name)
            when region_type = 'neighborhood' then coalesce(region_name, city)
            else region_name
        end as display_name,
        coalesce(city, metro, state_name, region_name) as hierarchy_name
    from source_regions
),
deduped as (
    select
        *,
        row_number() over (
            partition by region_id
            order by
                case region_type
                    when 'country' then 1
                    when 'state' then 2
                    when 'metro' then 3
                    when 'city' then 4
                    when 'neighborhood' then 5
                    else 99
                end,
                coalesce(region_name, ''),
                coalesce(city, ''),
                coalesce(metro, ''),
                coalesce(county_name, '')
        ) as row_num
    from normalized
)

select
    region_id,
    region_name,
    region_type,
    region_level,
    country_name,
    state_name,
    state_code,
    city,
    metro,
    county_name,
    display_name,
    hierarchy_name,
    case when region_type = 'country' then true else false end as is_country,
    case when region_type = 'state' then true else false end as is_state,
    case when region_type = 'metro' then true else false end as is_metro,
    case when region_type = 'city' then true else false end as is_city,
    case when region_type = 'neighborhood' then true else false end as is_neighborhood
from deduped
where row_num = 1
