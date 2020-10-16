# Install Helm Package Manager for K8S
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
# Add & refresh Helm repositories
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add gitlab https://charts.gitlab.io/
helm repo update
# Install HashiCorp Consul
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install consul
# Allow management of Consul from local console
export CONSUL_HTTP_ADDR="http://localhost:30101"
# Generate Gossip encryption key and create K8S Gossip Secret
GOSSIP_KEY=$(consul keygen)
kubectl create secret generic consul-gossip-encryption-key --from-literal=key="${GOSSIP_KEY}"
