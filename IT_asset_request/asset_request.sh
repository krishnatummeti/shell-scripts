#!/bin/bash

# File: asset_request.sh
# Description: Terminal-based IT Asset Request System

INVENTORY="inventory.txt"
LOG="requests_db.txt"
EMAIL_SCRIPT="notify_user.py"

echo "======= IT Asset Request System ======="
echo -n "Enter your Employee ID: "
read emp_id

echo -n "Enter your Name: "
read emp_name

echo ""
echo "📦 Available Assets:"
cat $INVENTORY
echo ""
echo -n "Enter the Asset Code you want to request: "
read asset_code

asset_line=$(grep "^$asset_code " $INVENTORY)

if [ -z "$asset_line" ]; then
    echo "❌ Invalid Asset Code. Exiting."
    exit 1
fi

asset_name=$(echo $asset_line | cut -d "-" -f2- | xargs)

timestamp=$(date "+%Y-%m-%d %H:%M:%S")
request_id=$(date +%s)  # Unique ID based on time

echo ""
echo "✅ Request Summary:"
echo "Request ID: $request_id"
echo "Employee: $emp_name ($emp_id)"
echo "Asset Requested: $asset_name"
echo "----------------------------------------"

echo "$timestamp | Request ID: $request_id | $emp_id | $emp_name | $asset_name" >> $LOG

echo ""
echo -n "Enter your Email for confirmation: "
read email

# Send confirmation via Python
python3 $EMAIL_SCRIPT "$emp_name" "$email" "$asset_name" "$request_id"
