#!/bin/sh
# run as root

yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine

yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2 wget

wget -O /etc/yum.repos.d/docker-ce.cn.repo http://fs.qianbao-inc.com/k8s/docker/docker-ce.cn.repo

yum install docker-ce -y

sed -i 's_ExecStart=/usr/bin/dockerd.*_ExecStart=/usr/bin/dockerd \\\n  --data-root=/home/data/docker \\\n  --registry-mirror=https://registry.docker-cn.com \\\n  --insecure-registry=harbor.wk.qianbao-inc.com --insecure-registry harbor-test.wk.qianbao-inc.com --insecure-registry reg.qianbao-inc.com_' /usr/lib/systemd/system/docker.service

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
systemctl status docker

