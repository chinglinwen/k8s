#!/bin/sh

curl -s http://fs.haodai.net/k8s/v1.14/addkubeconfig.sh | sh

node="$( ip addr show `ip r |grep default | awk '{ print $5 }'` | grep link -A 1 | grep -Po 'inet \K[\d.]+' )"
s1="$( echo $node | awk '{ print $2 }' FS='.' )"
suffix="$( echo $node | awk '{ print $4 }' FS='.' )"
if [ "x$s1" = "x31" ]; then
  net=21
else
  net=22
fi
patch="{\"metadata\":{\"annotations\":{\"kube-router.io/pod-cidr\":\"10.$net.$suffix.0/24\"}}}"
kubectl patch node $node -p $patch

# delete kubeconfig
rm -f ~/.kube/config
