#!/bin/sh

systemctl status docker &>/dev/null
if [ $? -ne 0 ]; then
  echo "docker is not running, may need install docker, or make the docker running."
  echo "install by run ../docker/install.sh"
  exit 1
fi

( which kubeadm && which kubelet && which kubectl ) > /dev/null
if [ $? -ne 0 ]; then
  echo "exit."
  exit 1
fi

#NOTE: assume bridge setting on everynode
#NOTE: assume bond1 is ready
