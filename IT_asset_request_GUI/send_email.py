import smtplib
import sys
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

if len(sys.argv) < 6:
    print("Usage: send_email.py <name> <emp_id> <email> <assets> <request_id>")
    sys.exit(1)

name = sys.argv[1]
emp_id = sys.argv[2]
recipient_email = sys.argv[3]
requested_assets = sys.argv[4].replace("\\n", "\n")
request_id = sys.argv[5]

# Email credentials (replace with your Gmail + app password)
sender_email = "krishnatummeti@gmail.com"
sender_password = "sqslafjksyewiyeq"

subject = f"IT Asset Request Confirmation (ID: {request_id})"
body = f"""
Hello {name},

Your IT asset request has been received successfully.

🔹 Request ID: {request_id}
🔹 Employee ID: {emp_id}

📦 Requested Items:
{requested_assets}

You will be contacted shortly by the IT department.

Best regards,  
IT Support Team
"""

message = MIMEMultipart()
message["From"] = sender_email
message["To"] = recipient_email
message["Subject"] = subject
message.attach(MIMEText(body, "plain"))

try:
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login(sender_email, sender_password)
        server.send_message(message)
    print("✅ Email sent successfully.")
except Exception as e:
    print(f"❌ Failed to send email: {e}")
    sys.exit(1)
