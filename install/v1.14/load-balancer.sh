#!/bin/sh
# install ipvs on all master nodes

export PRIVATE_IP="$( ip addr show `ip r |grep default | awk '{ print $5 }'` | \
                     grep link -A 1 | grep -Po 'inet \K[\d.]+' )"

ipvsadm -A -t $PRIVATE_IP:9443 -s wlc
ipvsadm -a -t $PRIVATE_IP:9443 -r 172.31.90.100:6443 -m
ipvsadm -a -t $PRIVATE_IP:9443 -r 172.31.90.101:6443 -m
ipvsadm -a -t $PRIVATE_IP:9443 -r 172.31.90.102:6443 -m

ipvsadm -l
ipvsadm-save -n > /etc/sysconfig/ipvsadm

# testing
wget http://fs.devops.haodai.net/soft/fileserver2 -O /usr/local/bin/fs && chmod +x /usr/local/bin/fs

curl 172.31.90.219:9443



export PRIVATE_IP="$( ip addr show `ip r |grep default | awk '{ print $5 }'` | \
                     grep link -A 1 | grep -Po 'inet \K[\d.]+' )"

ipvsadm -A -t $PRIVATE_IP:9444 -s wlc
ipvsadm -a -t $PRIVATE_IP:9444 -r 172.31.90.100:6443 -m


ipvsadm -A -t 172.31.90.219:9444 -s wlc
ipvsadm -a -t 172.31.90.219:9444 -r 172.31.90.100:6443 -m



echo "net.ipv4.conf.eth1.arp_ignore = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.eth1.arp_announce = 2" >> /etc/sysctl.conf
sysctl -p


/sbin/ifconfig lo down
/sbin/ifconfig lo up
echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
/sbin/ifconfig lo:0 172.31.90.219 broadcast 172.31.90.219 netmask 255.255.255.255 up
ip route add 172.31.90.219 via 0.0.0.0 dev lo:0
/bin/systemctl stop firewalld.service
setenforce 0

