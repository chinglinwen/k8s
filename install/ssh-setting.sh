#!/bin/sh

hosts="$( cat masters.txt )"
echo "$hosts" >> /etc/hosts

cat /dev/zero | ssh-keygen -q -N ""

ssh-copy-id root@master0
ssh-copy-id root@master1
ssh-copy-id root@master2

cat> /tmp/hello.sh<<'eof'
echo hello $(hostname)
eof

ssh master0 "bash -s" < /tmp/hello.sh
ssh master1 "bash -s" < /tmp/hello.sh
ssh master2 "bash -s" < /tmp/hello.sh

rm /tmp/hello.sh
