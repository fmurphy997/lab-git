#!/bin/bash
# Install Helm Package Manager for K8S
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
# Add & refresh Helm repositories
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add gitlab https://charts.gitlab.io/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
#####START OF CONSUL INSTALLATION#####
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install consul
export CONSUL_HTTP_ADDR="http://localhost:30101"
# Generate Gossip encryption key and create K8S Gossip Secret
GOSSIP_KEY=$(consul keygen)
# Make Persistent Volumes for Consul Statefulset
kubectl apply -f pv.yaml
kubectl create secret generic consul-gossip-encryption-key --from-literal=key="${GOSSIP_KEY}" -n hashi-consul
helm install hashi-consul hashicorp/consul -f consul-values.yml -n hashi-consul --atomic
consul members >> /home/vagrant/consul-node-status.log
#####END OF CONSUL INSTALLATION#####
