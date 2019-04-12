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
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl status docker


sed -i 's/kubelet.*$/kubelet --cgroup-driver=cgroupfs/g' /usr/lib/systemd/system/kubelet.service
sed -i 's/cgroupDriver.*/cgroupDriver: cgroupfs/' /var/lib/kubelet/config.yaml
sed -i 's/--cgroup-driver=.*\ /--cgroup-driver=cgroupfs\ /' /etc/sysconfig/kubelet

sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet