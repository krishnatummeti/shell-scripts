#!/bin/bash

# File paths
INVENTORY="inventory.txt"
LOG="requests_log.txt"
EMAIL_SCRIPT="send_email.py"

# Read inventory into array for Zenity
if [ ! -f "$INVENTORY" ]; then
    zenity --error --text="Inventory file not found!" --width=300
    exit 1
fi

mapfile -t items < "$INVENTORY"

# Show asset list using Zenity checklist
options=()
for line in "${items[@]}"; do
    code=$(echo "$line" | awk '{print $1}')
    name=$(echo "$line" | cut -d '-' -f2- | xargs)
    options+=("$code" "$name" FALSE)
done

selected_codes=$(zenity --list --checklist \
    --title="Select IT Assets" \
    --column="Select" --column="Code" --column="Asset" \
    "${options[@]}" \
    --width=600 --height=400)

if [ -z "$selected_codes" ]; then
    zenity --warning --text="No assets selected!" --width=300
    exit 1
fi

# Prompt for user details
emp_name=$(zenity --entry --title="Employee Name" --text="Enter your full name:")
emp_id=$(zenity --entry --title="Employee ID" --text="Enter your employee ID:")
email=$(zenity --entry --title="Email" --text="Enter your email address:")

if [[ -z "$emp_name" || -z "$emp_id" || -z "$email" ]]; then
    zenity --error --text="All fields are required!" --width=300
    exit 1
fi

# Convert asset codes to names
requested_assets=""
IFS="|" read -ra codes <<< "$selected_codes"
for code in "${codes[@]}"; do
    line=$(grep "^$code " "$INVENTORY")
    if [ -n "$line" ]; then
        asset_name=$(echo "$line" | cut -d '-' -f2- | xargs)
        requested_assets+="$asset_name\n"
    fi
done

# Create a unique request ID
request_id=$(date +%s)
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# Log the request
echo "$timestamp | $request_id | $emp_id | $emp_name | $requested_assets" >> "$LOG"

# Call the Python email script
python3 "$EMAIL_SCRIPT" "$emp_name" "$emp_id" "$email" "$requested_assets" "$request_id"

if [ $? -eq 0 ]; then
    zenity --info --title="Request Submitted" --text="Your asset request has been submitted and emailed." --width=300
else
    zenity --error --text="Failed to send confirmation email." --width=300
fi
