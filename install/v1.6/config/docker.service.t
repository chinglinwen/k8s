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
EnvironmentFile=/etc/sysconfig/ovs_config
EnvironmentFile=-/etc/sysconfig/kubernets_cluster_network
    
ExecStartPre=/apps/soft/kubernetes/bin/generate_subnet.py "$GENERATE_SUBNET_ARGS"
ExecStart=/usr/bin/dockerd $INSECURE_REGISTRY $DOCKER_STORAGE_OPTIONS $DOCKER_OPTS $DOCKER_OPT_BIP 
ExecStartPost=/apps/soft/kubernetes/bin/ovs_config.sh "$OVS_CONFIG_ARGS"
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

