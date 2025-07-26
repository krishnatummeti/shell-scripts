# File: send_email.py

import smtplib
import sys
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Check arguments
if len(sys.argv) < 6:
    print("Usage: send_email.py <name> <emp_id> <email> <assets> <request_id>")
    sys.exit(1)

name = sys.argv[1]
emp_id = sys.argv[2]
recipient = sys.argv[3]
assets = sys.argv[4].replace("\\n", "\n")  # Ensure line breaks
request_id = sys.argv[5]

# Replace with your Gmail credentials
sender_email = "krishnatummeti@gmail.com"
sender_password = "sqslafjksyewiyeq"  # Use Gmail App Password

# Compose message
subject = f"IT Asset Request Confirmation (ID: {request_id})"
body = f"""Hi {name},

Your IT asset request has been submitted successfully.

Employee ID: {emp_id}
Request ID: {request_id}

Requested Assets:
{assets}

You will be contacted once your assets are ready for delivery.

Best regards,  
IT Department
"""

# Build the email
msg = MIMEMultipart()
msg["From"] = sender_email
msg["To"] = recipient
msg["Subject"] = subject
msg.attach(MIMEText(body, "plain"))

# Send email via Gmail SMTP
try:
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login(sender_email, sender_password)
        server.send_message(msg)
    print("✅ Email sent successfully.")
except Exception as e:
    print(f"❌ Failed to send email: {e}")
    sys.exit(1)
