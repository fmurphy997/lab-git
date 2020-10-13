#!/bin/bash

./deployment_variables.sh

set -eo pipefail
discovery_token_ca_cert_hash="$(grep 'discovery-token-ca-cert-hash' /vagrant/kubeadm.log | head -n1 | awk '{print $2}')"
sudo kubeadm join ${CONTROLLER_IP}:${CONTROLLER_PORT} --token ${JOIN_TOKEN} --discovery-token-ca-cert-hash ${discovery_token_ca_cert_hash}
