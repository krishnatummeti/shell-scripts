#!/bin/bash

# IT Asset Request GUI Script using Zenity

INVENTORY="inventory.txt"
LOG="requests_log.txt"
EMAIL_SCRIPT="send_email.py"

# Make sure inventory file exists
if [ ! -f "$INVENTORY" ]; then
    zenity --error --text="❌ inventory.txt not found!" --width=300
    exit 1
fi

# Build Zenity checklist options (Select | Code | Asset | Status)
options=()
mapfile -t items < "$INVENTORY"
for line in "${items[@]}"; do
    code=$(echo "$line" | awk '{print $1}')
    name=$(echo "$line" | cut -d '-' -f2- | rev | cut -d '-' -f2- | rev | xargs)
    status=$(echo "$line" | awk -F '-' '{print $NF}' | xargs)
    options+=("FALSE" "$code" "$name" "$status")
done

# Show Zenity checklist
selected_codes=$(zenity --list --checklist \
    --title="🖥 Select IT Assets to Request" \
    --column="Select" --column="Code" --column="Asset" --column="Status" \
    "${options[@]}" \
    --width=800 --height=400)

if [ -z "$selected_codes" ]; then
    zenity --warning --text="⚠️ No assets selected." --width=300
    exit 1
fi

# Prompt for user details
emp_name=$(zenity --entry --title="Employee Name" --text="Enter your full name:")
emp_id=$(zenity --entry --title="Employee ID" --text="Enter your employee ID:")
email=$(zenity --entry --title="Email" --text="Enter your email address:")

if [[ -z "$emp_name" || -z "$emp_id" || -z "$email" ]]; then
    zenity --error --text="❌ All fields are required!" --width=300
    exit 1
fi

# Convert codes to asset names
requested_assets=""
IFS="|" read -ra codes <<< "$selected_codes"
for code in "${codes[@]}"; do
    line=$(grep "^$code " "$INVENTORY")
    if [ -n "$line" ]; then
        asset_name=$(echo "$line" | cut -d '-' -f2- | rev | cut -d '-' -f2- | rev | xargs)
        requested_assets+="$asset_name\n"
    fi
done

# Create unique request ID and timestamp
request_id=$(date +%s)
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# Log the request
echo "$timestamp | Request ID: $request_id | $emp_id | $emp_name | $requested_assets" >> "$LOG"

# Send email
python3 "$EMAIL_SCRIPT" "$emp_name" "$emp_id" "$email" "$requested_assets" "$request_id"

# Notify user
if [ $? -eq 0 ]; then
    zenity --info --title="✅ Request Submitted" --text="Your IT asset request has been submitted and emailed." --width=350
else
    zenity --error --title="❌ Email Failed" --text="There was a problem sending the confirmation email." --width=350
fi
