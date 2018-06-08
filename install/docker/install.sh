#!/bin/sh
# run as root

yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine

yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo


yum install docker-ce

cat | tee /etc/docker/daemon.json <<eof
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
eof

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
systemctl status docker


