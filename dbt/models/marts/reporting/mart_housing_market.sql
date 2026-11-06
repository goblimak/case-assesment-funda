select
    s.region_id,
    r.region_name,
    r.region_type,
    r.state_name,
    r.state_code,
    r.city,
    r.metro,
    r.county_name,
    r.display_name,
    d.month_date,
    d.year_number,
    d.month_number,
    d.month_name,
    s.monthly_sales_count,
    z.zhvi_value,
    i.inventory_count,
    m.market_temp_index,
    p.mean_days_on_market,
    c.new_construction_sales_count,
    h.income_needed_for_downpayment,
    g.zorf_growth_pct,
    y.zori_index,
    s.monthly_sales_count / nullif(z.zhvi_value, 0) as sales_per_zhvi_value,
    s.monthly_sales_count / nullif(i.inventory_count, 0) as sales_per_inventory,
    p.mean_days_on_market / nullif(s.monthly_sales_count, 0) as dom_per_sale
from {{ ref('fct_metro_sales') }} s
join {{ ref('dim_region') }} r
    on r.region_id = s.region_id
join {{ ref('dim_date') }} d
    on d.month_date = s.month_date
left join {{ ref('fct_neighborhood_zhvi') }} z
    on z.region_id = s.region_id
    and z.month_date = s.month_date
left join {{ ref('fct_metro_inventory') }} i
    on i.region_id = s.region_id
    and i.month_date = s.month_date
left join {{ ref('fct_metro_market_temp_index') }} m
    on m.region_id = s.region_id
    and m.month_date = s.month_date
left join {{ ref('fct_metro_mean_doz_pending') }} p
    on p.region_id = s.region_id
    and p.month_date = s.month_date
left join {{ ref('fct_metro_new_con_sales_count') }} c
    on c.region_id = s.region_id
    and c.month_date = s.month_date
left join {{ ref('fct_metro_new_homeowner_income_needed_downpayment') }} h
    on h.region_id = s.region_id
    and h.month_date = s.month_date
left join {{ ref('fct_national_zorf_growth') }} g
    on g.region_id = s.region_id
    and g.month_date = s.month_date
left join {{ ref('fct_city_zori') }} y
    on y.region_id = s.region_id
    and y.month_date = s.month_date
where d.month_date between date '2025-01-31' and date '2025-12-31'

