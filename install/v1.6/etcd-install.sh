#!/bin/sh
# etcd install
# remote execute this script on all nodes

# copy certs
cp ca.pem kubernetes-key.pem kubernetes.pem /etc/kubernetes/ssl


# download etcd and etcdctl

mkdir -p /apps/soft/etcd/var
mkdir -p /apps/soft/etcd/bin
wget http://fs.qianbao-inc.com/k8s/install/v1.6/soft/etcd-v3.1.5-linuxamd64.
tar.gz
tar -xvf etcd-v3.1.5-linux-amd64.tar.gz
mv etcd-v3.1.5-linux-amd64/etcd* /apps/soft/etcd/bin

export PATH=/apps/soft/etcd/bin:$PATH
echo 'export PATH=/apps/soft/etcd/bin:$PATH' >> /etc/profile


# setup service
cp service, generate service
it's need upload


systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd
