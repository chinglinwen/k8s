#!/bin/sh
# node install

# prepare

mkdir -p /apps/soft/kubernetes/bin/
chmod 755 /apps/soft/kubernetes/bin/generate_subnet.py
chmod 755 /apps/soft/kubernetes/bin/ovs_config.sh

why need install etcdctl (ovs need)


# download software (ovs, and docker)

# generate_subnet.py and ovs_config.sh


# docker config

# /etc/sysconfig/ovs_config文件共同使用
# {"Network":"10.66.192.0/20", "Gateway":"10.66.192.1", "SubnetLen": 25}


ETCDCTL_API=3 etcdctl --endpoints=https://$ETCD1:2379 --
cacert=/etc/kubernetes/ssl/ca.pem --cert=/etc/kubernetes/ssl/kubernetes.pem --
key=/etc/kubernetes/ssl/kubernetes-key.pem put /kubernetes/network/config '{"Network":"10.66.192.0/20", "Gateway":"10.66.192.1", "SubnetLen": 25}'


# 复制etcdctl工具
mkdir -p /apps/soft/etcd/bin/
# 从etcd的机器上复制etcdctl工具到本地的/apps/soft/etcd/bin
chmod 755 /apps/soft/etcd/bin/etcdctl
# 配置环境
export PATH=/apps/soft/etcd/bin:$PATH
echo 'export PATH=/apps/soft/etcd/bin:$PATH' >> /etc/profile


# 安装etcd3模块
# generate_subnet.py脚本需要安装etcd3模块
# 如果pip更新慢，可以使用阿里云的代理
mkdir -p ~/.pip
cat > ~/.pip/pip.conf <<EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
EOF
pip install etcd3


# install ovs

# 安装open vswitch
yum -y install make gcc openssl-devel autoconf automake rpm-build redhat-rpm-config
yum -y install python-devel openssl-devel kernel-devel kernel-debug-devel libtool wget
bridge-utils
mkdir -p ~/rpmbuild/SOURCES
cd ~; wget http://openvswitch.org/releases/openvswitch-2.5.0.tar.gz
cp openvswitch-2.5.0.tar.gz ~/rpmbuild/SOURCES/
tar xfz openvswitch-2.5.0.tar.gz
sed 's/openvswitch-kmod, //g' openvswitch-2.5.0/rhel/openvswitch.spec > openvswitch-
2.5.0/rhel/openvswitch_no_kmod.spec
rpmbuild -bb --nocheck ~/openvswitch-2.5.0/rhel/openvswitch_no_kmod.spec
yum -y localinstall ~/rpmbuild/RPMS/x86_64/openvswitch-2.5.0-1.x86_64.rpm
systemctl enable openvswitch.service
systemctl start openvswitch.service


# install docker
wget https://download.docker.com/linux/centos/docker-ce.repo -O
/etc/yum.repos.d/docker-ce.repo
yum -y install docker-ce-17.06.2.ce-1.el7.centos.x86_64

/etc/sysconfig/docker
/etc/systemd/system/docker.service

/etc/sysconfig/ovs_config
-/etc/sysconfig/kubernets_cluster_network


# 从master处拷贝证书和/root/.kube目录
cp kube.tgz /root/
cd /root; tar zxf kube.tgz
cp kubernetes.tgz /etc/
cd /etc; tar -zxf kubernetes.tgz


systemctl daemon-reload
systemctl enable docker
systemctl start docker

wget https://dl.k8s.io/v1.6.13/kubernetes-node-linux-amd64.tar.gz
tar -zxf kubernetes-node-linux-amd64.tar.gz
cp kubernetes/node/bin /apps/soft/kubernetes/ -rf
export PATH=/apps/soft/kubernetes/bin:$PATH
echo 'export PATH=/apps/soft/kubernetes/bin:$PATH' >> /etc/profile

kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper
--user=kubelet-bootstrap

# kubelet

mkdir -p /apps/soft/kubernetes/lib/kubelet

/etc/systemd/system/kubelet.service

systemctl daemon-reload
systemctl enable kubelet
systemctl start kubelet

# only one time?
kubectl get csr
kubectl certificate approve csr-2b308

# kube-proxy

/etc/systemd/system/kube-proxy.service

systemctl daemon-reload
systemctl enable kube-proxy
systemctl start kube-proxy


