# sys
timedatectl set-timezone Asia/Shanghai
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

echo "/apps/core-%e-%s-%u-%g-%p-%t" > /proc/sys/kernel/core_pattern
echo "kernel.core_pattern = /apps/core-%e-%s-%u-%g-%p-%t" >> /etc/sysctl.conf
sysctl -p


# dns ignore
# yum ignore

# firewall and network manager
systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl stop firewalld
systemctl disable firewalld
systemctl stop postfix
systemctl disable postfix
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# hostname ignore

# time sync?

# k8s directory
mkdir -p /root/local/bin

# ovs

# docker

# etcd

# k8s
