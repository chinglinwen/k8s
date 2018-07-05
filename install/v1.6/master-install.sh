#!/bin/sh
# master install

. ./remote-exec.sh

em ./haproxy-install.sh
em ./kube-master-install.sh
