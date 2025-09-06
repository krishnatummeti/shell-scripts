#!/bin/bash
##################################################################
# Date : 08-Feb-2025
# Author: Krishna Tummeti
# Website : TECH BASE HUB
# Purpose: Monitor service
# Get the hostname, IP address, and current date and time
##################################################################

HOSTNAME=$(hostname)
IP_ADDRESS=$(hostname -I | awk '{print $1}')
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Enter your email IDs
recipient="krishnatummeti@gmail.com,krishnatummeti@outlook.com"

# Mail subject
subject="Problem - Nginx alert - $HOSTNAME - $CURRENT_DATE"

# Function to generate HTML content for the email
generate_html_content() {
body="<html>
<head>
<style>
        body { font-family: Arial, sans-serif; }
        .container { width: 80%; margin: 20px auto; border: 1px solid #ccc; padding: 20px; border-radius: 5px; }
        .header { text-align: center; margin-bottom: 20px; }
        .status { font-size: 24px; color: #FF0000; font-weight: bold; text-align: center; margin-bottom: 20px;}
        .info { font-size: 16px; margin-bottom: 10px;}
        .action { margin-top: 20px; text-align: center;}
        .highlight { background-color: #f0f0f0; padding: 5px; border-radius: 3px; }
        .footer { text-align: center; margin-top: 20px; font-size: 12px; color: #666; }
</style>
    </head>
        <body>
            <div class='container'>
            <div class='header'>
                <h2>Nginx service alert</h2>
            </div>
                <hr>
                    <div class='info'><b>Hostname:</b> $HOSTNAME</div>
                    <div class='info'><b>IP Address:</b> $IP_ADDRESS</div>
                    <div class='info'><b>Current Date and Time:</b> $CURRENT_DATE</div>
                    <div class='info'><b>Operating System:</b> Oracle Linux Server 8.10</div>
                    <div class='info'><b>Severity: </b><span style='color: #FF0000;'>CRITICAL</span></div>
                <hr>
                    <div class='status'>Nginx is NOT running!</div>
                    <div class='action'>Action: Start the Nginx process using <code>sudo systemctl start nginx</code>.</div>
                <hr>
                    <div class='footer'><p>This is an automated monitoring notification. Please take action immediately.</p></div>
            </div>
        </body>
</html>"
}

# Function to send the email
send_email() {
echo -e "Subject: $subject\nMIME-Version: 1.0\nContent-Type: text/html\nTo: $recipient\n\n$body" | sendmail -t
}

# Main function to generate email and send it
main() {
generate_html_content
send_email
}

# Function to check Nginx process status
check_nginx_status() {
NGINX_COUNT=$(ps -ef | grep nginx | grep -v grep| wc -l)

if [ "$NGINX_COUNT" -eq "0" ]; then
NGINX_STATUS="Nginx is NOT running!"
echo "$NGINX_STATUS"
main
exit 1 # Exit if Nginx is not running
else
NGINX_STATUS="Nginx is running normally."
echo "$NGINX_STATUS"
exit 0 # Exit if Nginx is running
fi
}

# Start by checking Nginx status
check_nginx_status