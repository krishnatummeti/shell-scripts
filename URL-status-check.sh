#!/bin/bash

# Enable debugging mode to trace script execution
set -x

# Define the URL to check
url="https://techbasehub.com/"
# Extract the hostname from the URL
hostname=$(echo $url | awk -F / '{print $3}')

# Function to check the HTTP status of the URL
check_url () {
# Fetch the HTTP status code using curl
local url_status_code=$(curl -I $url | awk 'NR==1 {print $2}')
# Check if the status code is 200 (OK)
if [[ $url_status_code -eq 200 ]]; then
echo -e "The URL $url is accessible.\nThe hostname is $hostname.\nStatus code: $url_status_code"
else
echo "The URL $url is not accessible. Status code: $url_status_code"
fi
}

# Call the function to perform the URL check
check_url