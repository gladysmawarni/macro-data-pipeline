select
    year,
    floor(year / 10) * 10 as decade,
    year >= {{ var('forecast_start_year') }} as is_forecast_year
from (
    select 1999 + row_number() over (order by seq4()) as year
    from table(generator(rowcount => 32))   -- 2000 to 2031
)