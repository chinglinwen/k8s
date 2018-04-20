#!/bin/sh

n=${T:=1}

echo
echo "will try to destroy $n times..."
echo

i=0
while true; do
  pod="$( kubectl -n minions get pods 2>/dev/null | grep minion | grep Run | awk '{ print $1 }' )"
  if [ "x$pod" = "x" ]; then
    echo "it's not running"
    sleep 1
    continue
  fi
  ((i++))
  if [ $i -gt $n ]; then
    echo "complete $n times of destroy."
    break
  fi
  kubectl -n minions get pods 2>/dev/null | grep minion | grep Pend
  if [ $? -eq 0 ]; then
    echo "Got pending item, see what's happening"
    kubectl -n minions get pods 2>/dev/null | grep minion | grep Pend
    #exit 1
  fi
  echo "$i times of delete"
  kubectl -n minions delete pod $pod
  #sleep 5
done
