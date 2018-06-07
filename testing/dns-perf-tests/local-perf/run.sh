#!/bin/sh
if [ "x$1" = "x-h" ]; then
  echo "Usage: $0 dns-ip-addr"
  exit 1
fi
dnsip="$( kubectl get svc -o wide -n kube-system | grep dns | awk '{ print $3 }' )"
if [ "x$1" != "x" ]; then
  dns=$1
else
  dns=$dnsip
fi
./bin/queryperf-linux_amd64 -d domain.lst.queryperf -l 30 -s $dns -p 53
