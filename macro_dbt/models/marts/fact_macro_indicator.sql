select
    observation_id,
    country_code,      -- FK to dim_country
    indicator_code,    -- FK to dim_indicator
    year,              -- FK to dim_date
    source,
    value,
    is_forecast,
    yoy_change,
    yoy_pct_change
from {{ ref('int_macro_observations_yoy') }}