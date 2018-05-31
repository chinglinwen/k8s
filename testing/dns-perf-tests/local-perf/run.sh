#!/bin/sh
if [ "x$1" = "x" ]; then
  echo "Usage: $0 dns-ip-addr"
  exit 1
fi
dns=${1:=10.96.0.10}
./bin/queryperf-linux_amd64 -d domain.lst.queryperf -l 30 -s $dns -p 53
