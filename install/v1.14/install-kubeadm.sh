#!/bin/sh
# install kubeadm

sestatus | grep -e 'SELinux status:.*disabled' -e permissive
if [ $? -ne 0 ]; then
  echo "selinux not turned off"
  exit 1
fi

# iptables -L
# cat /sys/class/dmi/id/product_uuid # check unique

# remove old config
rm -f /var/lib/kubelet/config.yaml
rm -f /var/lib/kubelet/kubeadm-flags.env

# install kubeadm
which kubeadm &>/dev/null
if [ $? -ne 0 ]; then
  echo "installing kubeadm..."
  mkdir ~/soft
  cd ~/soft
  yum repolist
  yum install wget -y
  if [ ! -d k8sv1.14 ]; then
    wget http://fs.devops.haodai.net/k8s/k8sv1.14.tar.gz
    tar -xzf k8sv1.14.tar.gz
  fi
  cd k8sv1.14
  yum install -y *.rpm
  yum install -y ipvsadm
else
  echo "kubeadm installed already"
fi

# for kernel setting ( required )
modprobe br_netfilter

cat >/etc/modprobe.d/k8s.conf <<eof
[modules]
br_netfilter = r
eof

cat > /etc/sysctl.d/k8s.conf <<eof
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
eof

sysctl --system >/dev/null
sysctl -a | grep bridge-nf-call-iptables
if [ $? -ne 0 ]; then
  echo "setting bridge-nf-call-iptables err, check sysctl -a"
  exit 1
fi


cat > /etc/sysconfig/kubelet <<'eof'
KUBELET_EXTRA_ARGS=" --root-dir=/data/kubelet --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1 --cgroup-driver=cgroupfs --runtime-cgroups=/systemd/system.slice --kubelet-cgroups=/systemd/system.slice --read-only-port=10255"
eof

rm -f /var/lib/kubelet/config.yaml
rm -f /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# this somewhat not working
# mkdir /etc/systemd/system/kubelet.service.d 2>/dev/null
# echo "KUBELET_CGROUP_ARGS=\" --cgroup-driver=systemd\""  > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# this works
# sed -i 's/kubelet.*$/kubelet --cgroup-driver=systemd/g' /usr/lib/systemd/system/kubelet.service

sed -i 's/kubelet.*$/kubelet --cgroup-driver=cgroupfs/g' /usr/lib/systemd/system/kubelet.service
sed -i 's/cgroupDriver.*/cgroupDriver: cgroupfs/' /var/lib/kubelet/config.yaml
# sed -i 's/--cgroup-driver=.*\ /--cgroup-driver=cgroupfs\ /' /etc/sysconfig/kubelet

# cat > /etc/sysconfig/kubelet <<'eof'
# KUBELET_EXTRA_ARGS=" --root-dir=/data/kubelet --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1 --cgroup-driver=cgroupfs"
# eof
# echo "KUBELET_CGROUP_ARGS=\" --cgroup-driver=cgroupfs\""  > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl enable --now kubelet
systemctl daemon-reload
systemctl restart kubelet
systemctl status kubelet