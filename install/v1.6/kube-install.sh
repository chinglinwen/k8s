#!/bin/sh
# kubelet, kube-proxy install on all nodes.

curl -so /tmp/k8senv http://fs.qianbao-inc.com/k8s/install/v1.6/env
. /tmp/k8senv

# need install kube bin
kdir=/apps/soft/kubernetes
mkdir -p $kdir

if [ ! -f $kdir/bin/kubelet ]; then  
  echo "downloading... k8s"
  #if too slow, just do scp manually: /apps/soft/kubernetes/bin/* 10.64.166.12:/apps/soft/kubernetes/bin/
  wget http://fs.qianbao-inc.com/k8s/install/v1.6/soft/kubernetes-bin.tar.gz
  
  echo "untar..."
  tar -zxf kubernetes-bin.tar.gz -C $kdir

  export PATH=/apps/soft/kubernetes/bin:$PATH
  echo 'export PATH=/apps/soft/kubernetes/bin:$PATH' >> /etc/profile
fi

# will run after master
#kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --user=kubelet-bootstrap

# kubelet

mkdir -p /apps/soft/kubernetes/lib/kubelet

cat >/etc/systemd/system/kubelet.service<<eof
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/apps/soft/kubernetes/lib/kubelet
ExecStart=/apps/soft/kubernetes/bin/kubelet \\
  --address=$IP \\
  --hostname-override=$IP \\
  --pod-infra-container-image=reg.qianbao-inc.com/base/pod-infrastructure:latest \\
  --experimental-bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig \\
  --kubeconfig=/etc/kubernetes/kubelet-kubeconfig \\
  --require-kubeconfig \\
  --cert-dir=/etc/kubernetes/ssl \\
  --container-runtime=docker \\
  --cluster_dns=10.254.0.2 \\
  --cluster_domain=cluster.local. \\
  --hairpin-mode promiscuous-bridge \\
  --allow-privileged=true \\
  --serialize-image-pulls=false \\
  --register-node=true \\
  --logtostderr=true \\
  --kube-reserved=memory=1Gi \\
  --v=5
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
eof

systemctl daemon-reload
systemctl enable kubelet
systemctl start kubelet

# only one time?
kubectl get csr
kubectl certificate approve csr-2b308

# kube-proxy

cat >/etc/systemd/system/kube-proxy.service<<eof
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/apps/soft/kubernetes/bin/kube-proxy \\
  --bind-address=$IP \\
  --cluster-cidr=10.254.0.0/16 \\
   --hostname-override=$IP \\
  --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig \\
  --logtostderr=true \\
  #--log-dir=/var/log/kubernetes/ \\
  --v=5
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
eof

systemctl daemon-reload
systemctl enable kube-proxy
systemctl start kube-proxy

