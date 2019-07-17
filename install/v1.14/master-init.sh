#!/bin/sh

curl -s http://fs.haodai.net/k8s/v1.14/install-docker.sh| sh

curl -s http://fs.haodai.net/k8s/v1.14/install-kubeadm.sh | sh

curl -s http://fs.haodai.net/k8s/v1.14/pull-images.sh | sh