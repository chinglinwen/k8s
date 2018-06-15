  echo "# wait network for every node join, since our ip is fixed"
  while test ! -f /etc/cni/net.d/10-kuberouter.conf ; do
    echo waiting kube-router done
    sleep 1
  done
  cat /etc/cni/net.d/10-kuberouter.conf
  echo ok

