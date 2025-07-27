#!/bin/bash

INVENTORY="inventory.txt"
LOG="requests_log.txt"
EMAIL_SCRIPT="send_email.py"

if [ ! -f "$INVENTORY" ]; then
    zenity --error --text="❌ inventory.txt not found!" --width=300
    exit 1
fi

# Build Zenity checklist
options=()
mapfile -t items < "$INVENTORY"
for line in "${items[@]}"; do
    code=$(echo "$line" | awk '{print $1}')
    name=$(echo "$line" | cut -d '-' -f2- | rev | cut -d '-' -f2- | rev | xargs)
    status=$(echo "$line" | awk -F '-' '{print $NF}' | xargs)

    if [[ "$status" == "Available" ]]; then
        options+=("FALSE" "$code" "$name" "$status")
    else
        options+=("FALSE" "$code" "$name (Unavailable)" "$status")
    fi
done

selected_codes=$(zenity --list --checklist \
    --title="🖥 Select IT Assets to Request" \
    --column="Select" --column="Code" --column="Asset" --column="Status" \
    "${options[@]}" \
    --width=800 --height=400)

if [ -z "$selected_codes" ]; then
    zenity --warning --text="⚠️ No assets selected." --width=300
    exit 1
fi

# Collect user details
emp_name=$(zenity --entry --title="Employee Name" --text="Enter your full name:")
emp_id=$(zenity --entry --title="Employee ID" --text="Enter your employee ID:")
email=$(zenity --entry --title="Email" --text="Enter your email address:")

if [[ -z "$emp_name" || -z "$emp_id" || -z "$email" ]]; then
    zenity --error --text="❌ All fields are required!" --width=300
    exit 1
fi

# Ask for priority
priority=$(zenity --list \
    --title="Select Priority Level" \
    --text="How critical is this request?" \
    --radiolist \
    --column="Select" --column="Priority" \
    TRUE "High" FALSE "Medium" FALSE "Low")

if [ -z "$priority" ]; then
    zenity --error --text="❌ You must select a priority level!" --width=300
    exit 1
fi

# Validate selected assets
requested_assets=""
unavailable_assets=""
IFS="|" read -ra codes <<< "$selected_codes"
for code in "${codes[@]}"; do
    line=$(grep "^$code " "$INVENTORY")
    if [ -n "$line" ]; then
        name=$(echo "$line" | cut -d '-' -f2- | rev | cut -d '-' -f2- | rev | xargs)
        status=$(echo "$line" | awk -F '-' '{print $NF}' | xargs)
        if [[ "$status" ==]()]()
