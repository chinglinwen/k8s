#!/bin/sh

script="$1"
if [ "x$script" = "x" ]; then
  echo "script not provided, exit"
  exit 1
fi
base="$( pwd|sed 's/k8s.*/k8s\/install/' )"
while read line; do
  host="$( echo $line | awk '{ print $2 }' )"
  ssh $host "bash -s" < $script
done < $base/masters.txt
