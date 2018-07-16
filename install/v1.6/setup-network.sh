cat >/tmp/setupnetwork.sh <<eof
ETCDCTL_API=3 /apps/soft/etcd/bin/etcdctl --endpoints=https://$ETCD1:2379 --cacert=/etc/kubernetes/ssl/ca.pem \\
  --cert=/etc/kubernetes/ssl/kubernetes.pem --key=/etc/kubernetes/ssl/kubernetes-key.pem \\
  put /kubernetes/network/config '{"Network":"$CLUSTER_CIDR", "Gateway":"$GATEWAY", "SubnetLen": $SUBNET_LEN}'
eof
eo /tmp/setupnetwork.sh
