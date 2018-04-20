#!/bin/bash

master="$( kubectl get pod -l k8s-app=master -n minions | grep Running  | awk '{ print $1 }' )"
echo "Connecting to $master"

kubectl port-forward $master 8888:8888 --namespace=minions &

echo "See http://$( kubectl get ep -n minions | grep 8888 | awk '{ print $2}' )"/stats
