#!/bin/sh
# kubelet, kube-proxy install on all nodes.


# docker config

# install docker
wget http://fs.qianbao-inc.com/k8s/install/v1.6/soft/docker-ce.cn.repo -O /etc/yum.repos.d/docker-ce.repo
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


