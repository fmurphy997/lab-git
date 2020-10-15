# Install Helm Package Manager for K8S
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
# Add & refresh Helm repositories
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add gitlab https://charts.gitlab.io/
helm repo update
