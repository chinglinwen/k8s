#!/bin/sh

# for nfs mount client
yum -y install nfs-utils

curl -s http://fs.devops.haodai.net/k8s/v1.14/install-docker.sh| sh

curl -s http://fs.devops.haodai.net/k8s/v1.14/install-kubeadm.sh | sh

# join node
IP="$( ip addr show `ip r |grep default | awk '{ print $5 }'` | grep link -A 1 | grep -Po 'inet \K[\d.]+' )"
kubeadm join 172.31.90.219:6443 --token haqnew.eco2srqj2fndznew \
    --discovery-token-ca-cert-hash sha256:288d60408622143f1292b55f2bf3a4db6b496df62318cc56d1c3556e13a7cf82 --node-name $IP