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

# Email config (replace with your actual credentials and addresses)
sender_email = "krishnatummeti@gmail.com"
sender_password = "sqslafjksyewiyeq"
it_email = "krishnatummeti@gmail.com"  # IT department email

# Email content for employee
subject_user = f"IT Asset Request Confirmation (ID: {request_id})"
body_user = f"""
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
subject_it = f"[NEW REQUEST] {name} ({emp_id}) - Priority: {priority}"
body_it = f"""
New IT Asset Request Received:

🔹 Request ID: {request_id}
🔹 Employee Name: {name}
🔹 Employee ID: {emp_id}
🔹 Priority: {priority}

📦 Requested Assets:
{requested_assets}

This is an automated alert for the IT team.
"""

try:
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login(sender_email, sender_password)

        # Send email to employee
        msg_user = MIMEMultipart()
        msg_user["From"] = sender_email
        msg_user["To"] = recipient_email
        msg_user["Subject"] = subject_user
        msg_user.attach(MIMEText(body_user, "plain"))
        server.send_message(msg_user)

        # Send email to IT
        msg_it = MIMEMultipart()
        msg_it["From"] = sender_email
        msg_it["To"] = it_email
        msg_it["Subject"] = subject_it
        msg_it.attach(MIMEText(body_it, "plain"))
        server.send_message(msg_it)

    print("✅ Emails sent to employee and IT department.")
except Exception as e:
    print(f"❌ Failed to send email: {e}")
    sys.exit(1)
