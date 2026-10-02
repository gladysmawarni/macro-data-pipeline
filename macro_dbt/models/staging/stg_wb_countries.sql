SELECT
    id           AS country_code,
    name         AS country_name,
    region       AS region_code,
    incomelevel  AS income_level_code,
    capitalcity  AS capital_city,
    latitude,
    longitude,
    _loaded_at
FROM {{ source('raw', 'wb_countries') }}
WHERE NOT aggregate   -- drops "World", "Euro area", etc.