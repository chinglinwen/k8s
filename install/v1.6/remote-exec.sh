#!/bin/sh
. ./env

base="$( pwd | sed 's/k8s.*/k8s\/install\/v1.6/' )"

e (){
  list="$1"
  script="$2"
  while read host; do
    if [ -f "$script" ]; then
      ssh $host "bash -s" < "$script"
    else
      ssh -f $host -C "$script"
    fi
  done <<eof
$list
eof
}

etcdlist="$ETCD1
$ETCD2
$ETCD3"

masterlist="$MASTER1
$MASTER2"

nodelist="$NODE1
$NODE2
$NODE3"

ee (){
  e "$etcdlist" $1
  echo
  echo "etcd may need a little while to change to running status."
}

em (){
  e "$masterlist" $1
}

en (){
  e "$nodelist" $1
}

# execute on single server
eo (){
  e "$MASTER1" $1
}

ea (){
 ee $1
 em $1
 en $1
}

doscp (){
  src="$1"
  dst="$2"
  echo "src: $src, dst: $dst"
  while read host; do
    echo "start scp for host: $host"
    scp -r $src $host:$dst
  done <<eof
$ETCD1
$ETCD2
$ETCD3
$MASTER1
$MASTER2
$NODE1
$NODE2
$NODE3
eof
}
