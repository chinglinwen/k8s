#!/bin/sh

yum install -y http://fs.qianbao-inc.com/k8s/kubeadm/kubectl-1.10.2-0.x86_64.rpm
yum install -y http://fs.qianbao-inc.com/k8s/kubeadm/kubernetes-cni-0.6.0-0.x86_64.rpm \
   http://fs.qianbao-inc.com/k8s/kubeadm/kubelet-1.10.2-0.x86_64.rpm
yum install -y http://fs.qianbao-inc.com/k8s/kubeadm/kubeadm-1.10.2-0.x86_64.rpm

setenforce 0

sysctl -a|grep bridge-nf-call-ip  # usually ok

sed -i "s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl enable kubelet && systemctl restart kubelet

echo "kubelet waits in a crashloop for kubeadm to tell it what to do."
