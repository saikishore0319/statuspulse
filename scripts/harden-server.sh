#!/bin/bash
# Server Hardening Script for StatusPulse
set -e

echo "Starting server hardening..."

# 1. Update system
apt-get update && apt-get upgrade -y

# 2. Create non-root deploy user
if ! id "deploy" &>/dev/null; then
    echo "Creating deploy user..."
    adduser --disabled-password --gecos "" deploy
    usermod -aG sudo deploy
    echo "deploy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/deploy
fi

# 3. Harden SSH
SSH_PORT=${SSH_PORT:-2222}
echo "Hardening SSH (Port: $SSH_PORT)..."
sed -i "s/#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
# Note: User must manually add their SSH key to /home/deploy/.ssh/authorized_keys

# 4. Configure Firewall (UFW)
echo "Configuring UFW..."
ufw default deny incoming
ufw default allow outgoing
ufw allow $SSH_PORT/tcp
ufw allow 80/tcp
ufw allow 443/tcp
echo "y" | ufw enable

# 5. Install Docker & Compose
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce docker-compose-plugin
    usermod -aG docker deploy
fi

# 6. Set up Swap Space (for low-RAM free tier)
if [ ! -f /swapfile ]; then
    echo "Creating 2GB swap file..."
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# 7. Enable Unattended Upgrades
apt-get install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades

echo "Server hardening complete!"
