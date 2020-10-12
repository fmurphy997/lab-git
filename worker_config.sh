JOIN_TOKEN = "ayngk7.m1555duk5x2i3ctt"
CONTROLLER_IP = 172.16.30.100
MASTER_PORT = 8443

set -eo pipefail
discovery_token_ca_cert_hash="$(grep 'discovery-token-ca-cert-hash' /vagrant/kubeadm.log | head -n1 | awk '{print $2}')"
sudo kubeadm join #{CONTROLLER_IP}:#{MASTER_PORT} --token #{JOIN_TOKEN} --discovery-token-ca-cert-hash ${discovery_token_ca_cert_hash}
sudo rm -f /vagrant/kubeadm.log
