#!/bin/sh

cat <<eof
this script should execute on everynode, change ip and gateway accordingly
bond1 will be active outer interface.
eof

cd /etc/sysconfig/network-scripts/
mkdir bak
cp ifcfg-* bak

cat > ifcfg-bond1 <<eof
TYPE=BOND
DEVICE=bond1
ONBOOT=yes
NAME=bond1
BOOTPROTO=static
BONDING_OPTS="mode=4 miimon=100"
IPADDR=172.28.46.2
NETMASK=255.255.255.0
GATEWAY=172.28.46.254
eof

cat > ifcfg-eth2 <<eof
TYPE=Ethernet
DEVICE=eth2
ONBOOT=yes
BOOTPROTO=none
MASTER=bond1
SLAVE=yes
eof

cat > ifcfg-eth3 <<eof
TYPE=Ethernet
DEVICE=eth3
ONBOOT=yes
BOOTPROTO=none
MASTER=bond1
SLAVE=yes
eof

service network restart

cat<<eof
# execute on everynode
brctl addif kube-bridge bond0
brctl show
eof
