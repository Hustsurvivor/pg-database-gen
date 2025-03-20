#!/bin/bash

# Define the list of tables
TABLES=("call_center" "catalog_page" "catalog_returns" "catalog_sales"
        "customer" "customer_address" "customer_demographics" "date_dim"
        "household_demographics" "income_band" "inventory" "item"
        "promotion" "reason" "ship_mode" "store" "store_returns"
        "store_sales" "time_dim" "warehouse" "web_page"
        "web_returns" "web_sales" "web_site")

# Define base paths
BASE_PATH="tpcds/table/format_data"
DATABASE="tpcds"  # Name of the database

# Loop through each table and import data
for TABLE in "${TABLES[@]}"; do
    echo "Importing $TABLE ..."
    # Define file path
    FILE_PATH="$BASE_PATH/$TABLE.dat"
    
    # Check if the file exists before attempting to import
    if [ -f "$FILE_PATH" ]; then
        psql -d "$DATABASE" -c "\copy $TABLE FROM '$FILE_PATH' WITH (FORMAT csv, DELIMITER '|', NULL '');"
    else
        echo "File $FILE_PATH not found, skipping import for $TABLE."
    fi
done