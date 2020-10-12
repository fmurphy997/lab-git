$worker_config = <<SCRIPT
set -eo pipefail
discovery_token_ca_cert_hash="$(grep 'discovery-token-ca-cert-hash' /vagrant/kubeadm.log | head -n1 | awk '{print $2}')"
sudo kubeadm join #{MASTER_IP}:#{MASTER_PORT} --token #{KUBE_TOKEN} --discovery-token-ca-cert-hash ${discovery_token_ca_cert_hash}
SCRIPT
