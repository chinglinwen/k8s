#!/bin/sh
# ovs install on all nodes.

# prepare

kdir=/apps/soft/kubernetes
mkdir -p $kdir/bin/

curl -so $kdir/bin/ovs_config.sh http://fs.qianbao-inc.com/k8s/install/v1.6/soft/ovs_config.sh
curl -so $kdir/bin/generate_subnet.py http://fs.qianbao-inc.com/k8s/install/v1.6/soft/generate_subnet.py

chmod 755 $kdir/bin/ovs_config.sh
chmod 755 $kdir/bin/generate_subnet.py


# download software (ovs and docker)
# generate_subnet.py and ovs_config.sh
# docker config

# all certs and tools need to be ready

if [ ! -f /usr/local/bin/etcdctl ]; then
  wget http://fs.qianbao-inc.com/k8s/install/v1.6/soft/etcdctl -O /usr/local/bin/etcdctl
  chmod 755 /usr/local/bin/etcdctl
fi


ETCDCTL_API=3 etcdctl --endpoints=https://$ETCD1:2379 --cacert=/etc/kubernetes/ssl/ca.pem \
  --cert=/etc/kubernetes/ssl/kubernetes.pem --key=/etc/kubernetes/ssl/kubernetes-key.pem \
  put /kubernetes/network/config '{"Network":"$CLUSTER_CIDR", "Gateway":"$GATEWAY", "SubnetLen": $SUBNET_LEN}'


mkdir -p ~/.pip
cat > ~/.pip/pip.conf <<EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
EOF
pip install etcd3


# install ovs

yum -y install make gcc openssl-devel autoconf automake rpm-build redhat-rpm-config
yum -y install python-devel openssl-devel kernel-devel kernel-debug-devel libtool wget bridge-utils


yum -y install http://fs.qianbao-inc.com/k8s/install/v1.6/soft/openvswitch-2.5.0-1.x86_64.rpm


systemctl enable openvswitch.service
systemctl start openvswitch.service

