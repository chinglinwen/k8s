#!/bin/sh

ns=${NS:=qb-pro}
pods="$( kubectl get pods -n $ns -o wide|grep fs )"
echo "$pods" | while read l; do
  ((i++))
  name="$( echo $l | awk '{ print $1 }' )"
  nodeip="$( echo $l | awk '{ print $7 }' )"
  info="$i $name $nodeip"
  echo "$info"
  cmd="echo "$info" > /data/index.html"
  kubectl exec $name -n $ns -- sh -c "$cmd"
done
