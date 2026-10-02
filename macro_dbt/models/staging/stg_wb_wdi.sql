select
    {{ dbt_utils.generate_surrogate_key(['economy', 'series', '"TIME"']) }} as wb_observation_id,
    economy                                        as country_code,
    series                                         as indicator_code,
    case series
        when 'NY.GDP.PCAP.CD' then 'GDP per capita (current US$)'
        when 'SP.DYN.LE00.IN' then 'Life expectancy at birth'
    end as indicator_name,
    try_cast(replace("TIME", 'YR', '') as integer) as year,
    try_cast(value as float)                       as value,
    _loaded_at
from {{ source('raw', 'wb_wdi') }}
where value is not null