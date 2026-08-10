import pandas as pd
import psycopg2
from psycopg2.extras import execute_values

def clean_numeric(val):
    """Remove commas and convert to integer, handle empty values"""
    if pd.isna(val):
        return None
    s = str(val).replace(",", "")
    try:
        return int(s)
    except ValueError:
        return None

# Read Excel Export sheet
df_export = pd.read_excel("import_export.xlsx", sheet_name="Export")

# Clean & rename columns to match DB schema
df_export = df_export.rename(columns={
    "Date of data": "data_month",
    "Commodity code": "hs_code",
    "Commodity": "commodity_name",
    "Quantity": "quantity",
    "Unit": "unit",
    "Supplementary Quantity": "supplementary_quantity",
    "Supplementary Unit": "supplementary_unit",
    "US dollar": "usd_value"
})

# Clean all numeric columns that go into BIGINT fields
numeric_columns = ["quantity", "supplementary_quantity", "usd_value"]
for col in numeric_columns:
    df_export[col] = df_export[col].apply(clean_numeric)

# Insert into raw_export_hs (upsert: overwrite if exists)
conn = psycopg2.connect(
    host="localhost",
    dbname="ai_trade",
    user="trade_app",
    password="LocalTest123"
)
cur = conn.cursor()

rows = [
    tuple(r) for r in df_export[
        ["data_month","hs_code","commodity_name","quantity","unit",
         "supplementary_quantity","supplementary_unit","usd_value"]
    ].values
]

execute_values(cur, """
    INSERT INTO raw_export_hs (
        data_month, hs_code, commodity_name, quantity, unit,
        supplementary_quantity, supplementary_unit, usd_value
    )
    VALUES %s
    ON CONFLICT (data_month, hs_code) DO UPDATE
    SET
        quantity = EXCLUDED.quantity,
        supplementary_quantity = EXCLUDED.supplementary_quantity,
        usd_value = EXCLUDED.usd_value;
""", rows)

conn.commit()
cur.close()
conn.close()
print("Export raw data imported successfully.")