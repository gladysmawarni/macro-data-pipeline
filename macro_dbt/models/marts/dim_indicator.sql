select
    indicator_code,
    indicator_name,
    unit,
    source,
    category,
    unit like '%change%' as is_rate   -- rates vs levels
from {{ ref('indicators') }}