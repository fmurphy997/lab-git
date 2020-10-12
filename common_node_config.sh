#!/bin/bash
K8S_VERSION=1.19.2-00
# Disable Swap for the Current Instance
sudo swapoff -a
# Disable Swap Permanently
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
# Add Repositories & GPG Keys for Docker & K8S
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update --quiet
# Install Docker, K8S & mDNS Responder
sudo apt-get install -y docker-ce kubelet=$K8S_VERSION kubeadm=$K8S_VERSION kubectl=$K8S_VERSION avahi-daemon libnss-mdns unattended-upgrades --quiet
# Docker Configuration
sudo touch /etc/docker/daemon.json && sudo chmod 500 /etc/docker/daemon.json
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
sudo systemctl daemon-reload
sudo usermod -aG docker vagrant
# Enable 
sudo systemctl enable kubelet && sudo systemctl restart kubelet
sudo systemctl enable docker && sudo systemctl restart docker
# Configure automatic security updates
cat < EOF | sudo tee /etc/apt/apt.conf.d/50unattended-upgrades
Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}-security";
        "${distro_id}ESMApps:${distro_codename}-apps-security";
        "${distro_id}ESM:${distro_codename}-infra-security";
};
Unattended-Upgrade::Package-Blacklist {
};
Unattended-Upgrade::DevRelease "false";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
EOF
# Security update and package cleanup frequency (in days)
cat < EOF | sudo tee /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "1";
APT::Periodic::Unattended-Upgrade "1";
EOF
