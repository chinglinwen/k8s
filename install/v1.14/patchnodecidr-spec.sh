#!/bin/sh

curl -s http://fs.devops.haodai.net/k8s/v1.14/addkubeconfig.sh | sh

node="$( ip addr show `ip r |grep default | awk '{ print $5 }'` | grep link -A 1 | grep -Po 'inet \K[\d.]+' )"

cidr="$( kubectl get node $node -o yaml | grep podCIDR | awk '{ print $2 }' | grep '/' )"
if [ $? -eq 0 ]; then
  echo "node already got cidr: $cidr"
  exit
fi

echo "trying assign cidr to node $node"

# default node cidr
net=21

s1="$( echo $node | awk '{ print $2 }' FS='.' )"
suffix="$( echo $node | awk '{ print $4 }' FS='.' )"
if [ "x$s1" = "x90" ]; then
  net=22
fi

echo $node | grep '172.16' > /dev/null
if [ $? -eq 0 ]; then
  net=23
fi

newcidr="10.$net.$suffix.0/24"

patch="{\"spec\":{\"podCIDR\":\"$newcidr\"}}"
kubectl patch node $node -p $patch

# delete kubeconfig
rm -f ~/.kube/config
