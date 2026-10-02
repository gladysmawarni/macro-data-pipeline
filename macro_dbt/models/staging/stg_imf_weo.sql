select
    {{ dbt_utils.generate_surrogate_key(['country', 'indicator', 'time_period']) }} as imf_observation_id,
    country                              as country_code,
    indicator                            as indicator_code,
    case indicator
        when 'NGDP_RPCH' then 'Real GDP growth'
        when 'PCPIPCH'   then 'Inflation, average consumer prices'
        when 'LUR'       then 'Unemployment rate'
    end                                  as indicator_name,
    try_cast(time_period as integer)     as year,
    try_cast(value as float)             as value,
    try_cast(time_period as integer) >= {{ var('forecast_start_year') }} as is_forecast,
    _loaded_at
from {{ source('raw', 'imf_weo') }}
where value is not null