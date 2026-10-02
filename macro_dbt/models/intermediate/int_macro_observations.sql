with imf as (

    select
        'IMF'        as source,
        country_code,
        indicator_code,
        indicator_name,
        year,
        value,
        is_forecast,
        _loaded_at
    from {{ ref('stg_imf_weo') }}

),

wb as (

    select
        'World Bank' as source,
        country_code,
        indicator_code,
        indicator_name,
        year,
        value,
        false        as is_forecast,   -- WDI only reports actuals
        _loaded_at
    from {{ ref('stg_wb_wdi') }}

),

unioned as (
    select * from imf
    union all
    select * from wb
)

select
    {{ dbt_utils.generate_surrogate_key(['source', 'country_code', 'indicator_code', 'year']) }} as observation_id,
    *
from unioned