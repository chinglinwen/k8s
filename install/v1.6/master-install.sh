#!/bin/sh
# master install

. ./remote-exec.sh

em ./haproxy-install.sh
em ./kube-master-install.sh

kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --user=kubelet-bootstrap
