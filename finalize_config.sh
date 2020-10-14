# Set K8S Internal-IP on all nodes
sudo sed -i 's/.$//' /var/lib/kubelet/kubeadm-flags.env
sudo sed -i "s/$/ --node-ip=$KUBELET_IP/" "/var/lib/kubelet/kubeadm-flags.env"
sudo sed -i 's/$/"/' /var/lib/kubelet/kubeadm-flags.env
sudo systemctl daemon-reload
sudo systemctl restart kubelet
