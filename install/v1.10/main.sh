#!/bin/sh
# prepare docker and kubeadm tools

./remote-exec.sh ./docker/install.sh
./remote-exec.sh ./kubeadmtools.sh
