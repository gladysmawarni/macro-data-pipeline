with base as (

    select
        *,
        lag(value) over (partition by source, country_code, indicator_code order by year) as prior_value,
        lag(year)  over (partition by source, country_code, indicator_code order by year) as prior_year
    from {{ ref('int_macro_observations') }}

)

select
    observation_id,
    source,
    country_code,
    indicator_code,
    indicator_name,
    year,
    value,
    is_forecast,

    -- only compare consecutive years, so a data gap doesn't produce a fake change
    case when prior_year = year - 1
         then value - prior_value
    end as yoy_change,

    -- % change only makes sense for level indicators, not for rates
    case when prior_year = year - 1
          and prior_value <> 0
          and indicator_code in ('NY.GDP.PCAP.CD', 'SP.DYN.LE00.IN')
         then (value / prior_value - 1) * 100
    end as yoy_pct_change,

    _loaded_at
from base