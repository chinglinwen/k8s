#!/bin/sh

n=${N:=1}

i=1
while true; do
  if [ $i -gt $n ]; then
    echo "complete $n times of destroy."
    break
  fi
  pod="$( kubectl -n minions get pods 2>/dev/null | grep minion | grep Run | awk '{ print $1 }' )"
  if [ "x$pod" = "x" ]; then
    echo "it's not running"
    sleep 1
    continue
  fi
  echo "$i times of delete"
  ((i++))
  kubectl -n minions delete deploy minion-1
  ./run-minion-deploy-manner.sh
  #sleep 5
done
echo "over $i times"

echo "End time: $(date "+%s%N")"
