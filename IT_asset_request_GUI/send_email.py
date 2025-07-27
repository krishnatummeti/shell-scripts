import smtplib
import sys
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

if len(sys.argv) < 7:
    print("Usage: send_email.py <name> <emp_id> <email> <assets> <request_id> <priority>")
    sys.exit(1)

name = sys.argv[1]
emp_id = sys.argv[2]
recipient_email = sys.argv[3]
requested_assets = sys.argv[4].replace("\\n", "\n")
request_id = sys.argv[5]
priority = sys.argv[6]

# Email setup
sender_email = "krishnatummeti@gmail.com"  # <-- replace with your email
sender_password = "sqslafjksyewiyeq"  # <-- replace with 16-digit app password
it_email = "krishnatummeti@gmail.com"       # <-- replace with your IT email address

# Email content for employee
subject = f"IT Asset Request Confirmation (ID: {request_id})"
body = f"""
Hello {name},

Your IT asset request has been received successfully.

🔹 Request ID: {request_id}
🔹 Employee ID: {emp_id}
🔹 Priority: {priority}

📦 Requested Assets:
{requested_assets}

You will be contacted shortly by the IT department.

Best regards,  
IT Support Team
"""

# Email content for IT
it_subject = f"[NEW REQUEST] {name} ({emp_id}) - Priority: {priority}"
it_body = f"""
New IT Asset Request Received:

🔹 Request ID: {request_id}
🔹 Employee Name: {name}
🔹 Employee ID: {emp_id}
🔹 Priority: {priority}

📦 Requested Assets:
{requested_assets}

This is an automa
