#!/bin/sh
# get token
kubectl describe secret prometheus-k8s -n monitoring | \
        grep 'token:' | awk '{ print $2}' FS=':' | tr -d '\t'