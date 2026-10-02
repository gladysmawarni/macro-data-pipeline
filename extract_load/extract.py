import wbgapi as wb # Worldbank
import sdmx # IMF
import pandas as pd
import time

import logging
logging.getLogger("sdmx").setLevel(logging.ERROR)

COUNTRY_LIST = ["USA", "CAN", "GBR", "DEU", "ESP", "IND", "CHN", "JPN", "KOR"]
IMF_CODE_LIST = ["NGDP_RPCH", "PCPIPCH", "LUR"]
WB_CODE_LIST = ["NY.GDP.PCAP.CD", "SP.DYN.LE00.IN"]


def get_imf_data(start_year="2000", end_year="2026") -> pd.DataFrame:
    client = sdmx.Client("IMF_DATA")
    frames = []

    for country in COUNTRY_LIST:
        for code in IMF_CODE_LIST:
            try:
                msg = client.data(
                    "WEO",
                    key=f"{country}.{code}.A",  # COUNTRY.INDICATOR.FREQUENCY
                    params={"startPeriod": start_year, "endPeriod": end_year},
                )
                df = sdmx.to_pandas(msg).reset_index()
                frames.append(df)
            except Exception as e:
                print(f"IMF: skipped {country}/{code}: {e}")
            time.sleep(1)  # be polite to the API

    return pd.concat(frames, ignore_index=True)


def get_wb_data(start_year=2000, end_year=2026) -> pd.DataFrame:
    # fetch() yields one dict per country x indicator x year (long format)
    rows = wb.data.fetch(
        WB_CODE_LIST,
        economy=COUNTRY_LIST,
        time=range(start_year, end_year + 1),
    )
    return pd.DataFrame(list(rows))


def get_wb_countries() -> pd.DataFrame:
    # all economies, including aggregates like "World" (we filter those in dbt)
    return wb.economy.DataFrame(skipAggs=False).reset_index()