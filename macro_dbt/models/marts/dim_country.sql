select
    c.country_code,
    c.country_name,
    r.region_name,
    i.income_level_name,
    i.income_level_order,
    c.capital_city,
    c.latitude,
    c.longitude
from {{ ref('stg_wb_countries') }} c
left join {{ ref('region_names') }} r on c.region_code = r.region_code
left join {{ ref('income_levels') }} i on c.income_level_code = i.income_level_code
where c.country_code in (select distinct country_code from {{ ref('int_macro_observations') }})