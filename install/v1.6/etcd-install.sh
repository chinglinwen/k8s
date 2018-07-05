#!/bin/sh
# etcd install
# remote execute this script on all etcd nodes

curl -so /tmp/k8senv http://fs.qianbao-inc.com/k8s/install/v1.6/env
. /tmp/k8senv

# cert-create will copy certs

# download etcd and etcdctl

rm -rf /apps/soft/etcd/var

mkdir -p /apps/soft/etcd/var
mkdir -p /apps/soft/etcd/bin
if [ ! -f etcd-v3.1.5-linux-amd64.tar.gz ]; then
  wget http://fs.qianbao-inc.com/k8s/install/v1.6/soft/etcd-v3.1.5-linux-amd64.tar.gz
  tar -xf etcd-v3.1.5-linux-amd64.tar.gz
  mv etcd-v3.1.5-linux-amd64/etcd* /apps/soft/etcd/bin
fi

export PATH=/apps/soft/etcd/bin:$PATH
echo 'export PATH=/apps/soft/etcd/bin:$PATH' >> /etc/profile

IP="$( ip a | grep 'inet ' | grep -v -e docker -e 127.0.0.1 -e 'vir' | awk '{ print $2 }' | cut -f1 -d'/' )"
SUFFIX="$( echo $IP | awk '{ print $NF }' FS='.' )"


SUFFIX1="$( echo $ETCD1 | awk '{ print $NF }' FS='.' )"
SUFFIX2="$( echo $ETCD2 | awk '{ print $NF }' FS='.' )"
SUFFIX3="$( echo $ETCD3 | awk '{ print $NF }' FS='.' )"

echo "suffix: $SUFFIX1 $SUFFIX2 $SUFFIX3"

#cat >/etc/systemd/system/etcd.service<<"eof"
service="
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
Type=notify
WorkingDirectory=/apps/soft/etcd/var/
EnvironmentFile=-/etc/etcd/etcd.conf
ExecStart=/apps/soft/etcd/bin/etcd \\
  --name=etcd-$SUFFIX \\
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \\
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \\
  --peer-cert-file=/etc/kubernetes/ssl/kubernetes.pem \\
  --peer-key-file=/etc/kubernetes/ssl/kubernetes-key.pem \\
  --trusted-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --initial-advertise-peer-urls=https://$IP:2380 \\
  --listen-peer-urls=https://$IP:2380 \\
  --listen-client-urls=https://$IP:2379,http://127.0.0.1:2379 \\
  --advertise-client-urls=https://$IP:2379 \\
  --initial-cluster-token=etcd-cluster-0 \\
  --initial-cluster=etcd-$SUFFIX1=https://$ETCD1:2380,etcd-$SUFFIX2=https://$ETCD2:2380,etcd-$SUFFIX3=https://$ETCD3:2380 \\
  --initial-cluster-state=new \\
  --data-dir=/apps/soft/etcd/var/
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
"

echo "$service" >/etc/systemd/system/etcd.service

systemctl daemon-reload
systemctl enable etcd
systemctl restart etcd
systemctl status etcd

