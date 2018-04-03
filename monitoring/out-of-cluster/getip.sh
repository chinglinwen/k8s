#!/bin/sh
# get apiserver ip
kubectl cluster-info | grep master | awk '{ print $2 }' FS='//' | awk '{ print $1 }' FS=':'
