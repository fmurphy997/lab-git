# Initialize K8S cluster
sudo kubeadm init kubeadm init --image-repository #{IMAGE_REPO} \
             --apiserver-advertise-address=#{MASTER_IP} \
             --apiserver-bind-port=#{MASTER_PORT} \
             --kubernetes-version v#{KUBE_VER} \
             --pod-network-cidr=#{POD_NW_CIDR} \
             --token #{KUBE_TOKEN} \
             --token-ttl 0 | tee /vagrant/kubeadm.log
mkdir -p "/home/vagrant/.kube"
sudo cp -i "/etc/kubernetes/admin.conf" "/home/vagrant/.kube/config"
sudo chown vagrant:vagrant "/home/vagrant/.kube/config"
# Install WeaveNet CNI
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# Install Helm Package Manager for K8S
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
# Cleanup
sudo rm -f get_helm.sh
sudo rm -f master_config.sh
