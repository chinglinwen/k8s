#!/bin/bash

echo "Starting master..."

kubectl create namespace minions
kubectl create -f mysql.yaml

kub="kubectl --namespace=minions"

while ! $kub get pods|grep mysql|grep -i Running|cut -f1 -d" "|grep mysql;do
  sleep 1
done

cnt=`$kub get pods|grep mysql|grep -i Running|cut -f1 -d" "`

while ! $kub exec -ti $cnt -- test -f /tmp/mariadb_ok; do
  sleep 1
done

kubectl create -f master.yaml

while true; do
  master="$( kubectl get pod -l k8s-app=master -n minions | grep Running  | awk '{ print $1 }' )"
  if [ "x$master" != "x" ]; then
    break
  fi
  echo "waiting master online...."
done

echo "Done"
