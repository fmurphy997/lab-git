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
#Set Internal-IP for Kubelet service
sudo sed -i 's/.$//' /var/lib/kubelet/kubeadm-flags.env
sudo sed -i "s/$/ --node-ip=$KUBELET_IP/" "/var/lib/kubelet/kubeadm-flags.env"
sudo sed -i 's/$/"/' /var/lib/kubelet/kubeadm-flags.env
# Install Helm Package Manager for K8S
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
# Cleanup
sudo rm -f get_helm.sh
sudo rm -f master_config.sh
