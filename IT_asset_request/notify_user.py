# File: notify_user.py
# Usage: python3 notify_user.py "Name" "email@example.com" "Asset Name" "Request ID"

import smtplib
import sys
from email.message import EmailMessage

if len(sys.argv) != 5:
    print("Usage: python3 notify_user.py <name> <email> <asset> <request_id>")
    sys.exit(1)

name = sys.argv[1]
recipient = sys.argv[2]
asset = sys.argv[3]
request_id = sys.argv[4]

EMAIL_ADDRESS = "your-email@gmail.com"
EMAIL_PASSWORD = "your-app-password"  # Use App Password

msg = EmailMessage()
msg['Subject'] = f"Asset Request Confirmation [ID: {request_id}]"
msg['From'] = EMAIL_ADDRESS
msg['To'] = recipient
msg.set_content(f"""
Hi {name},

Your request for the asset:

    {asset}

has been successfully received.
Request ID: {request_id}

We will notify you once it's ready for delivery.

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
