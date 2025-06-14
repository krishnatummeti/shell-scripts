#!/bin/bash
set -vx
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Exit on error
set -e

# ENV set

ARCH=amd64
PLATFORM=$(uname -s)_$ARCH



# growpart /dev/nvme0n1 4
# lvextend -l +50%FREE /dev/RootVG/rootVol
# lvextend -l +50%FREE /dev/RootVG/varVol
# xfs_growfs /
# xfs_growfs /var


# docker install 

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user 
sudo newgrp docker
echo "User added to docker group"


# Install Docker Compose (latest as of May 2025)
sudo curl -L "https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version > /tmp/docker-compose_version.txt


# kubectl install

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client > /tmp/kubectl_version.txt


# eksctl install

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
eksctl version > /tmp/eksctl_version.txt