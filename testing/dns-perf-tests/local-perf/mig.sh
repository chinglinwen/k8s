#!/bin/sh
if [ "x$1" = "x" ]; then
  echo "Usage: $0 dns-ip-addr"
  exit 1
fi
dns=${1:=10.96.0.10}
./bin/mig-linux_amd64 -s $dns -p 53 -d domain.lst.mig -l 35000 -n 100000 -o /dev/null
