# Macroeconomic Analytics Pipeline

> **Note:** The project shown in this portfolio is a small-scale replica of the work I did. The original is business-owned and can't be disclosed.

## Overview

An ELT pipeline that loads IMF and World Bank macroeconomic data into Snowflake, models it with dbt into a tested star schema, and serves a Power BI dashboard for comparing countries on growth, inflation, unemployment, income, and life expectancy.

## What it does

```
IMF API ──┐
          ├─ Python ─► Snowflake RAW ─► dbt staging ─► intermediate ─► marts ─► Power BI
World Bank API ──┘
```

- **Extract and load:** Python pulls data from the IMF and World Bank APIs and lands it untouched in Snowflake.
- **Transform:** dbt cleans and standardizes the data, combines both sources, and builds a star schema (`fact_macro_indicator` plus country, indicator, and date dimensions).
- **Test and document:** dbt tests (`unique`, `not_null`, `relationships`, `accepted_values`) and source freshness checks protect data quality, and dbt docs provide lineage from source to dashboard.
- **Visualize:** Power BI reads the marts through a read-only role to compare countries against their long-run averages.

## Notes

- For rate indicators (growth, inflation, unemployment), `yoy_change` is in percentage points. For levels (GDP per capita, life expectancy), `yoy_pct_change` is the more useful number.

## Tech stack

Python, Snowflake, dbt, SQL, Power BI
