import os
from datetime import datetime, timezone

import pandas as pd
import snowflake.connector
from dotenv import load_dotenv
from snowflake.connector.pandas_tools import write_pandas

load_dotenv()


def get_connection():
    return snowflake.connector.connect(
        account=os.environ["SNOWFLAKE_ACCOUNT"],
        user=os.environ["SNOWFLAKE_USER"],
        password=os.environ["SNOWFLAKE_PASSWORD"],
        role=os.environ["SNOWFLAKE_ROLE"],
        warehouse=os.environ["SNOWFLAKE_WAREHOUSE"],
        database=os.environ["SNOWFLAKE_DATABASE"],
        schema=os.environ["SNOWFLAKE_SCHEMA"],
    )


def load_raw(df: pd.DataFrame, table_name: str) -> int:
    """Load a DataFrame into RAW.<table_name> exactly as received."""
    df = df.copy()

    # Snowflake convention: uppercase column names (avoids case-sensitivity headaches)
    df.columns = [c.upper() for c in df.columns]

    # Audit column: this is what dbt source freshness will use later
    df["_LOADED_AT"] = datetime.now(timezone.utc).replace(tzinfo=None)

    conn = get_connection()
    try:
        success, _, nrows, _ = write_pandas(
            conn,
            df,
            table_name=table_name.upper(),
            auto_create_table=True,
            overwrite=True,
            use_logical_type=True,   # keeps datetime columns as TIMESTAMP
        )
        return nrows
    finally:
        conn.close()