#!/bin/bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p "/home/vagrant/.kube"
sudo cp -i /etc/kubernetes/admin.conf "/home/vagrant/.kube/config"
sudo chown vagrant:vagrant "/home/vagrant/.kube/config"
sleep 2m
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
sudo rm -f get_helm.sh
