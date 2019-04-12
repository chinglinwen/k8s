#!/bin/sh

curl -s http://fs.devops.haodai.net/k8s/v1.14/install-docker.sh| sh

curl -s http://fs.devops.haodai.net/k8s/v1.14/install-kubeadm.sh | sh

# join node
IP="$( ip addr show `ip r |grep default | awk '{ print $5 }'` | grep link -A 1 | grep -Po 'inet \K[\d.]+' )"
kubeadm join 172.31.90.219:6443 --token w0dn8y.d2ih2dlfsstcm9bc \
    --discovery-token-ca-cert-hash sha256:90143f348f7a74bf0c2d696fce1c0a9ec9ae9284e77d850fbc3d9a907b2263bf --node-name $IP