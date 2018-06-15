#!/bin/sh


while read node; do
  kubectl drain $node --delete-local-data --force --ignore-daemonsets
  kubectl delete node  $node
done<<eof
$( kubectl get nodes | grep -v NAME | cut -f1 -d' ' )
eof
kubeadm reset
rm -rf /var/lib/etcd

cat<<'eof'

# execute the following on every node

systemctl stop kubelet
docker kill $(docker ps -q)
systemctl restart docker 
ip link delete kube-bridge


iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

iptables -nvL

rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*

ifconfig kube-bridge down
ifconfig kube-dummy-if down
ifconfig docker0 down

rm -rf /etc/kubernetes

rm -rf /home/data/rook

systemctl restart kubelet

eof


echo "end."
