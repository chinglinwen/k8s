#!/bin/sh
# master install

. ./remote-exec.sh

#en ./kernel.sh # try manual kernel upgrade

en ./ovs-install.sh
en ./docker-install.sh
en ./kube-install.sh

