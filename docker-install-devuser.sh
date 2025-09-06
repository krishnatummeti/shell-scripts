#!/bin/bash
set -vx

# ENV set
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

# Ensure system is updated
sudo dnf -y update

# Docker installation
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to Docker group (change 'devuser' if different)
sudo usermod -aG docker devuser

# Fix Docker socket permissions
sudo chown root:docker /var/run/docker.sock
sudo chmod 660 /var/run/docker.sock

# Docker Compose standalone install (optional, if not using plugin)
sudo curl -L "https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version > /tmp/docker-compose_version.txt

# kubectl install (Amazon EKS v1.33)
# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl
# sudo chmod +x ./kubectl
# sudo mv ./kubectl /usr/local/bin/
# kubectl version --client > /tmp/kubectl_version.txt

# eksctl install
# curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz"
# tar -xzf eksctl_${PLATFORM}.tar.gz -C /tmp && rm eksctl_${PLATFORM}.tar.gz
# sudo mv /tmp/eksctl /usr/local/bin/
# eksctl version > /tmp/eksctl_version.txt
