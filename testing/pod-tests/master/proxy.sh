#!/bin/bash

echo "Connecting to $master"

kubectl port-forward $master 8888:8888 --namespace=minions &

echo "See http://$( kubectl get ep -n minions | grep 8888 | awk '{ print $2}' )"/stats
