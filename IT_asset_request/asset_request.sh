#!/bin/bash

# File: asset_request.sh
# Description: IT Asset Request System (Multi-item support)

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
cat "$INVENTORY"
echo ""

echo -n "Enter the Asset Code(s) you want to request (separated by space): "
read -a asset_codes  # Read into an array

requested_assets=""
invalid_codes=()
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
request_id=$(date +%s)

for code in "${asset_codes[@]}"; do
    asset_line=$(grep "^$code " "$INVENTORY")
    if [ -z "$asset_line" ]; then
        invalid_codes+=("$code")
    else
        asset_name=$(echo "$asset_line" | cut -d "-" -f2- | xargs)
        requested_assets+="$asset_name\n"
        echo "$timestamp | Request ID: $request_id | $emp_id | $emp_name | $asset_name" >> "$LOG"
    fi
done

if [ ${#invalid_codes[@]} -ne 0 ]; then
    echo "❌ Invalid Asset Code(s): ${invalid_codes[*]}"
    exit 1
fi

echo ""
echo "✅ Request Summary:"
echo "Request ID: $request_id"
echo "Employee: $emp_name ($emp_id)"
echo -e "Assets Requested:\n$requested_assets"
echo "----------------------------------------"

echo -n "Enter your Email for confirmation: "
read email

# Send email using Python
python3 "$EMAIL_SCRIPT" "$emp_name" "$email" "$requested_assets" "$request_id"
