#!/bin/bash

# Define tables and paths
tables=(
    "call_center"
    "catalog_page"
    "catalog_returns"
    "catalog_sales"
    "customer"
    "customer_address"
    "customer_demographics"
    "date_dim"
    "household_demographics"
    "income_band"
    "inventory"
    "item"
    "promotion"
    "reason"
    "ship_mode"
    "store"
    "store_returns"
    "store_sales"
    "time_dim"
    "warehouse"
    "web_page"
    "web_returns"
    "web_sales"
    "web_site"
)

data_path="tpcds/table"   # directory of data files
target_path="tpcds/table/format_data"  # directory for formatted data files

# Create target directory if it doesn't exist
if [ ! -d "$target_path" ]; then
    mkdir -p "$target_path"
fi

# Read data and strip the last two characters (assuming the last two characters are '|')
for table in "${tables[@]}"; do
    echo "Processing table: $table"
    file_path="$data_path$table.dat"
    target_file_path="$target_path$table.dat"
    
    # Check if file exists before processing
    if [ -f "$file_path" ]; then
        while IFS= read -r line; do
            echo "${line%??}" >> "$target_file_path"  # Strip the last two characters (assumed to be '|')
        done < "$file_path"
    else
        echo "File $file_path not found, skipping..."
    fi
done