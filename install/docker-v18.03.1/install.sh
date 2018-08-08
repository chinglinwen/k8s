#!/bin/sh

# install docker
rpm -qa|grep docker-ce >/dev/null
if [ $? -ne 0 ]; then
  #wget http://fs.qianbao-inc.com/k8s/install/v1.6/soft/docker-ce.cn.repo -O /etc/yum.repos.d/docker-ce.repo
  yum -y install http://fs.qianbao-inc.com/k8s/install/v1.6/soft/container-selinux-2.42-1.gitad8f0f7.el7.noarch.rpm
  yum -y install http://fs.qianbao-inc.com/k8s/docker/docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm
fi

cat >/etc/sysconfig/docker<<"eof"
DOCKER_OPTS="--registry-mirror=https://registry.docker-cn.com --live-restore=true --ip-masq=false --iptables=false  --log-level=info --userland-proxy=true --log-driver=json-file --log-opt=max-size=100m --log-opt=max-file=5"
DOCKER_STORAGE_OPTIONS="--data-root=/apps/docker --storage-driver=overlay2"
INSECURE_REGISTRY="--insecure-registry harbor.wk.qianbao-inc.com --insecure-registry harbor-test.wk.qianbao-inc.com --insecure-registry reg.qianbao-inc.com"
eof


cat >/etc/systemd/system/docker.service<<'eof'
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker

EnvironmentFile=/etc/sysconfig/docker

ExecStart=/usr/bin/dockerd $INSECURE_REGISTRY $DOCKER_STORAGE_OPTIONS $DOCKER_OPTS 
ExecStartPost=/usr/sbin/sysctl -w net.ipv4.conf.docker0.send_redirects=0
ExecStartPost=/usr/sbin/sysctl -w net.ipv4.conf.all.send_redirects=0
ExecReload=/bin/kill -s HUP  $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
RestartSec=5
#StartLimitBurst=3#
#StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
eof


systemctl daemon-reload
systemctl enable docker
systemctl start docker
systemctl status docker

docker run harbor.wk.qianbao-inc.com/k8s/hello
