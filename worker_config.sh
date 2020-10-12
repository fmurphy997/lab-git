set -eo pipefail
discovery_token_ca_cert_hash="$(grep 'discovery-token-ca-cert-hash' /vagrant/kubeadm.log | head -n1 | awk '{print $2}')"
sudo kubeadm join #{CONTROLLER_IP}:#{MASTER_PORT} --token #{JOIN_TOKEN} --discovery-token-ca-cert-hash ${discovery_token_ca_cert_hash}
sudo rm -f /vagrant/kubeadm.log
