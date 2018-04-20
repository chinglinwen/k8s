#!/bin/sh

cleanurl="http://$( kubectl get ep -n minions 2>/dev/null | grep 8888 | awk '{ print $2}' )/cleanup"
curl -s $cleanurl &>/dev/null
if [ $? -ne 0 ]; then
  echo "cleanup fail, may not exist"
  exit 1
fi
echo "clean up sql done."

echo "try cleanup deploy and pods..."
kubectl get deploy -n minions | grep minion | awk '{ print $1 }' | xargs kubectl -n minions delete deploy 2>/dev/null
kubectl get pods -n minions | grep minion | grep Run | awk '{ print $1 }' | xargs kubectl -n minions delete pod 2>/dev/null

while true; do
  kubectl get pod -n minions | grep minion >/dev/null
  if [ $? -ne 0 ]; then
    break
  fi
  echo "waiting minion deleting...."
  sleep 1
done

echo "all minions deleted."
