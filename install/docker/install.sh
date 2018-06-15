#!/bin/sh
# run as root

yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine

yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

wget -O /etc/yum.repos.d/docker-ce.cn.repo http://fs.qianbao-inc.com/k8s/docker/docker-ce.cn.repo

yum install docker-ce

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
systemctl status docker

