#!/bin/sh

systemctl status docker &>/dev/null
if [ $? -ne 0 ]; then
  echo "docker is not running, may need install docker, or make the docker running."
  echo "install by run ../docker/install.sh"
  exit 1
fi
