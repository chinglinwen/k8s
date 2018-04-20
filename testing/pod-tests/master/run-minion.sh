#!/bin/bash
nodename="  $( kubectl get nodes -o yaml | grep kubernetes.io/hostname| tail -1 )"
sed 's_NODENAME_'"$nodename"'_' minion-rc.yaml | kubectl create -f -

