"""
Load the raw Kaggle e-commerce CSV into MySQL.

Expected input:
    data/raw/amazon_sales_dataset.csv

Expected environment variables:
    MYSQL_HOST
    MYSQL_PORT
    MYSQL_USER
    MYSQL_PASSWORD
    MYSQL_DATABASE
"""

from pathlib import Path
import os

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text


PROJECT_ROOT = Path(__file__).resolve().parents[2]
RAW_FILE = PROJECT_ROOT / "data" / "raw" / "amazon_sales_dataset.csv"
TABLE_NAME = "raw_orders"

DATE_COLUMNS = ["order_date", "ship_date", "delivery_date"]
NUMERIC_COLUMNS = ["quantity", "unit_price", "discount", "shipping_cost", "total_sales"]


def get_connection_settings() -> dict[str, str]:
    load_dotenv(PROJECT_ROOT / ".env")

    password = os.getenv("MYSQL_PASSWORD")
    if not password:
        raise ValueError("MYSQL_PASSWORD is missing. Add it to a local .env file.")

    return {
        "host": os.getenv("MYSQL_HOST", "localhost"),
        "port": os.getenv("MYSQL_PORT", "3306"),
        "user": os.getenv("MYSQL_USER", "root"),
        "password": password,
        "database": os.getenv("MYSQL_DATABASE", "ecommerce_dw"),
    }


def build_database_url(settings: dict[str, str], include_database: bool = True) -> str:
    database_part = f"/{settings['database']}" if include_database else ""
    return (
        f"mysql+pymysql://{settings['user']}:{settings['password']}"
        f"@{settings['host']}:{settings['port']}{database_part}"
    )


def load_raw_csv() -> pd.DataFrame:
    if not RAW_FILE.exists():
        raise FileNotFoundError(f"Raw CSV not found: {RAW_FILE}")

    df = pd.read_csv(RAW_FILE)

    for column in DATE_COLUMNS:
        df[column] = pd.to_datetime(df[column], errors="coerce")

    for column in NUMERIC_COLUMNS:
        df[column] = pd.to_numeric(df[column], errors="coerce")

    return df


def main() -> None:
    settings = get_connection_settings()
    df = load_raw_csv()

    server_engine = create_engine(build_database_url(settings, include_database=False))
    with server_engine.begin() as connection:
        connection.execute(text(f"CREATE DATABASE IF NOT EXISTS {settings['database']}"))

    database_engine = create_engine(build_database_url(settings, include_database=True))
    df.to_sql(TABLE_NAME, con=database_engine, if_exists="replace", index=False)

    print(f"Loaded {len(df):,} rows into MySQL table `{TABLE_NAME}`.")
    print(f"Columns: {list(df.columns)}")


if __name__ == "__main__":
    main()
