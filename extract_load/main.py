from extract import get_imf_data, get_wb_data, get_wb_countries
from load import load_raw

tables = {
    "imf_weo": get_imf_data,
    "wb_wdi": get_wb_data,
    "wb_countries": get_wb_countries,
}

for table_name, fn in tables.items():
    df = fn()
    print(df.head(1))  # eyeball the shape before loading
    n = load_raw(df, table_name)
    print(f"Loaded {n} rows into RAW.{table_name.upper()}")
