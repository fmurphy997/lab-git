sudo swapoff -a
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
sudo apt autoremove
sudo apt-get update
sudo apt-get install -y docker-ce kubelet=1.19.2-00 kubeadm=1.19.2-00 kubectl=1.19.2-00 avahi-daemon libnss-mdns
sudo apt update
sudo apt upgrade -y
sudo reboot
