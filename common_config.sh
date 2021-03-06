#!/bin/bash

source ./deployment_variables.conf

# Disable Swap for the Current Instance
sudo swapoff -a
# Disable Swap Permanently
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
# Some network stack tweaking since Linux bridging is used
cat << EOF | sudo tee /etc/sysctl.d/10-network-security.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_nonlocal_bind = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
# Add Repositories & GPG Keys for Docker & K8S
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
# Install Docker, K8S & mDNS Responder
sudo apt-get install -y docker-ce kubelet=$K8S_APT_VERSION kubeadm=$K8S_APT_VERSION kubectl=$K8S_APT_VERSION avahi-daemon libnss-mdns unattended-upgrades
# Docker Configuration
sudo touch /etc/docker/daemon.json && sudo chmod 500 /etc/docker/daemon.json
cat << EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
sudo usermod -aG docker vagrant
# Restart and enable services 
sudo systemctl daemon-reload
sudo systemctl enable kubelet && sudo systemctl restart kubelet
sudo systemctl enable docker && sudo systemctl restart docker
# Configure automatic security updates
cat << EOF | sudo tee /etc/apt/apt.conf.d/50unattended-upgrades
Unattended-Upgrade::Allowed-Origins {
        "${DISTRO_ID}:${DISTRO_CODENAME}";
        "${DISTRO_ID}:${DISTRO_CODENAME}-security";
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
cat << EOF | sudo tee /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "5";
APT::Periodic::Unattended-Upgrade "1";
EOF
# Pipe Hostname & NAT IP to be displayed at end of Vagrantfile Run
# echo "echo $HOSTNAME "can be reached at" $NAT_IP" >> /vagrant/exitInterview.cfg
