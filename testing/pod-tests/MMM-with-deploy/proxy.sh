#!/bin/bash

while true; do
  master="$( kubectl get pod -l k8s-app=master -n minions | grep Running  | awk '{ print $1 }' )"
  if [ "x$master" != "x" ]; then
    break
  fi
  echo "waiting master online...."
done

echo "Connecting to $master"

kubectl port-forward $master 8888:8888 --namespace=minions &

