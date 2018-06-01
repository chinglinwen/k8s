#!/bin/sh

pods="$( kubectl get pods -n qb-pro -o wide|grep fs )"
echo "$pods" | while read l; do
  ((i++))
  name="$( echo $l | awk '{ print $1 }' )"
  nodeip="$( echo $l | awk '{ print $7 }' )"
  info="$i $name $nodeip"
  echo "$info"
  cmd="echo "$info" > /data/index.html"
  kubectl exec $name -n qb-pro -- sh -c "$cmd"
done
