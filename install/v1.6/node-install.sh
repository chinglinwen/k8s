#!/bin/sh
# master install

. ./remote-exec.sh

en ./ovs-install.sh
en ./docker-install.sh
en ./kube-install.sh

