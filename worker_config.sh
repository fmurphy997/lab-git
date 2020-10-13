#!/bin/bash

source ./deployment_variables.conf

set -eo pipefail
discovery_token_ca_cert_hash="$(grep 'discovery-token-ca-cert-hash' /vagrant/kubeadm.log | head -n1 | awk '{print $2}')"
sudo kubeadm join ${CONTROLLER_IP}:${CONTROLLER_PORT} --token ${JOIN_TOKEN} --discovery-token-ca-cert-hash ${discovery_token_ca_cert_hash}
sudo sed -i 's/.$//' /var/lib/kubelet/kubeadm-flags.env
sudo sed -i "s/$/ --node-ip=$KUBELET_IP/" "/var/lib/kubelet/kubeadm-flags.env"
sudo sed -i 's/$/"/' /var/lib/kubelet/kubeadm-flags.env
sudo systemctl daemon-reload
sudo systemctl restart kubelet
