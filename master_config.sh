#!/bin/bash

source ./deployment_variables.conf

# Initialize K8S cluster
sudo kubeadm init --image-repository ${IMAGE_REPO} \
             --apiserver-advertise-address=${CONTROLLER_IP} \
             --apiserver-bind-port=${CONTROLLER_PORT} \
             --kubernetes-version v${K8S_VERSION} \
             --pod-network-cidr=${POD_NW_CIDR} \
             --token ${JOIN_TOKEN} \
             --token-ttl 0 | sudo tee /vagrant/kubeadm.log
mkdir -p "/home/vagrant/.kube"
sudo cp -i "/etc/kubernetes/admin.conf" "/home/vagrant/.kube/config"
sudo chown vagrant:vagrant "/home/vagrant/.kube/config"
# Install WeaveNet CNI
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# Set K8S Internal-IP to listen on non-NAT interface
sudo sed -i 's/.$//' /var/lib/kubelet/kubeadm-flags.env
sudo sed -i "s/$/ --node-ip=$KUBELET_IP/" "/var/lib/kubelet/kubeadm-flags.env"
sudo sed -i 's/$/"/' /var/lib/kubelet/kubeadm-flags.env
sudo systemctl daemon-reload
sudo systemctl restart kubelet
# Install HashiCorp Consul
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install consul
export CONSUL_HTTP_ADDR="http://localhost:30101"
# Quick Cleanup
sudo rm -f master_config.sh
