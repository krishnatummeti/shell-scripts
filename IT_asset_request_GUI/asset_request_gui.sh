#!/bin/bash

INVENTORY="inventory.txt"
LOG="requests_log.txt"
EMAIL_SCRIPT="send_email.py"

if [ ! -f "$INVENTORY" ]; then
    zenity --error --text="❌ inventory.txt not found!" --width=300
    exit 1
fi

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

emp_name=$(zenity --entry --title="Employee Name" --text="Enter your full name:")
emp_id=$(zenity --entry --title="Employee ID" --text="Enter your employee ID:")
email=$(zenity --entry --title="Email" --text="Enter your email address:")

if [[ -z "$emp_name" || -z "$emp_id" || -z "$email" ]]; then
    zenity --error --text="❌ All fields are required!" --width=300
    exit 1
fi

requested_assets=""
unavailable_assets=""
IFS="|" read -ra codes <<< "$selected_codes"
for code in "${codes[@]}"; do
    line=$(grep "^$code " "$INVENTORY")
    if [ -n "$line" ]; then
        name=$(echo "$line" | cut -d '-' -f2- | rev | cut -d '-' -f2- | rev | xargs)
        status=$(echo "$line" | awk -F '-' '{print $NF}' | xargs)
        if [[ "$status" == "Available" ]]; then
            requested_assets+="$name\n"
        else
            unavailable_assets+="$name\n"
        fi
    fi
done

if [ -n "$unavailable_assets" ]; then
    zenity --error --title="Unavailable Items Selected" \
    --text="You selected unavailable items:\n\n$unavailable_assets\n\nPlease deselect them and try again." --width=400
    exit 1
fi

request_id=$(date +%s)
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

echo "$timestamp | Request ID: $request_id | $emp_id | $emp_name | $requested_assets" >> "$LOG"

python3 "$EMAIL_SCRIPT" "$emp_name" "$emp_id" "$email" "$requested_assets" "$request_id"

if [ $? -eq 0 ]; then
    zenity --info --title="✅ Request Submitted" --text="Your IT asset request has been submitted and emailed." --width=350
else
    zenity --error --title="❌ Email Failed" --text="There was a problem sending the confirmation email." --width=350
fi
