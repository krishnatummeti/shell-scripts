# File: notify_user.py
# Usage: python3 notify_user.py "Name" "email@example.com" "Asset List" "Request ID"

import smtplib
import sys
from email.message import EmailMessage

if len(sys.argv) != 5:
    print("Usage: python3 notify_user.py <name> <email> <assets> <request_id>")
    sys.exit(1)

name = sys.argv[1]
recipient = sys.argv[2]
assets = sys.argv[3].replace("\\n", "\n")  # Proper newline handling
request_id = sys.argv[4]

# Replace with your Gmail account and app password
EMAIL_ADDRESS = "your-email@gmail.com"
EMAIL_PASSWORD = "your-app-password"  # Use Gmail App Password

msg = EmailMessage()
msg['Subject'] = f"Asset Request Confirmation [ID: {request_id}]"
msg['From'] = EMAIL_ADDRESS
msg['To'] = recipient

msg.set_content(f"""
Hi {name},

Your request for the following asset(s) has been successfully received:

{assets}

Request ID: {request_id}

We will notify you once your items are ready for delivery.

Thanks,
IT Department
""")

try:
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
        smtp.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        smtp.send_message(msg)
    print("📧 Email sent successfully.")
except Exception as e:
    print(f"❌ Failed to send email: {e}")
