#!/bin/sh
# install docker 18.06.2
out="$( rpm -qa | grep docker-ce-18.06.2 )"
if [ $? -ne 0 ]; then
  echo "removing exist version: $out "
  yum remove -y docker-ce*
fi

which docker &>/dev/null
if [ $? -ne 0 ]; then
  echo "installing docker..."
  \rm -f /etc/yum.repos.d/docker-ce.repo
  \rm -f /etc/yum.repos.d/kubernetes.repo
  
  sudo yum remove docker-ce \
                    docker-common \
                    docker-selinux \
                    docker-engine
  
  sudo yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2
  
  sudo yum-config-manager \
      --add-repo \
      http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  
  #yum install -y docker-ce-18.09.4
  yum install -y  docker-ce-18.06.2.ce
else
  echo "docker installed already"
fi

# https://kubernetes.io/docs/setup/cri/
# we changed to use systemd as cgroupdriver
 
mkdir /etc/docker 2>/dev/null
cat << EOF > /etc/docker/daemon.json
{
 "registry-mirrors": [ "https://5s7givlk.mirror.aliyuncs.com"],
 "exec-opts": ["native.cgroupdriver=cgroupfs"],
 "insecure-registries":["http://harbor.haodai.net"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "1000m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
# sudo systemctl daemon-reload
# sudo systemctl restart docker
# sudo systemctl status docker --no-pager

#mkdir -p /data/docker
# --bip=1.1.1.1/24

# the /data/docker must be large, though it can change later
cat > /etc/sysconfig/docker <<eof
DOCKER_OPTION=" --data-root=/data/docker"
eof

sed -i -e 's,ExecStart=,EnvironmentFile=/etc/sysconfig/docker\nExecStart=,' /usr/lib/systemd/system/docker.service
sed -i -e 's/dockerd/dockerd $DOCKER_OPTION/' /usr/lib/systemd/system/docker.service

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl status docker --no-pager

# sudo groupadd docker
# sudo usermod -aG docker $USER
# newgrp docker
# id
docker run hello-world

echo "docker install ok"