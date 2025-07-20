#!/bin/bash
set -euo pipefail
set -x

# Step 1: Update system and clean package metadata
sudo dnf -y update
sudo dnf clean all

# Step 2: Add Jenkins repo and GPG key
sudo curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Step 3: Install Java and Jenkins
sudo dnf install -y java-17-openjdk jenkins || sudo dnf --nogpgcheck install -y jenkins

# Step 4: Enable and start Jenkins
sudo systemctl enable --now jenkins
sudo systemctl status jenkins

java -version
# Step 5: Open firewall port if firewalld is enabled (uncomment if needed)
# sudo firewall-cmd --permanent --add-port=8080/tcp
# sudo firewall-cmd --reload

# Step 6: Print initial admin password
echo "Initial Jenkins admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword


# Connect to jenkins You public IP Port :8080   http://public_IP:8080 
