#!/bin/sh

pods="$( kubectl get pods -n qb-pro -o wide|grep fs )"
echo "$pods" | while read l; do
  ((i++))
  name="$( echo $l | awk '{ print $1 }' )"
  kubectl -n qb-pro cp desert.jpg $name:/data/
  echo "$i $name done"
done
