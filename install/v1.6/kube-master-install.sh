#!/bin/sh
# kube-apiserver, kube-controller-manager and kube-scheduler install on masters. 

curl -so /tmp/k8senv http://fs.qianbao-inc.com/k8s/install/v1.6/env
. /tmp/k8senv

IP="$( ip a | grep 'inet ' | grep -v -e docker -e 127.0.0.1 -e 'vir' -e "$VIP" | awk '{ print $2 }' | cut -f1 -d'/' )"

# cert is already on it

kdir=/apps/soft/kubernetes
mkdir -p $kdir

if [ ! -d $kdir/bin/ ]; then  
  echo "downloading... k8s"
  wget -q http://fs.qianbao-inc.com/k8s/install/v1.6/soft/kubernetes-bin.tar.gz
  
  echo "untar..."
  tar -zxf kubernetes-bin.tar.gz -C $kdir
fi
export PATH=/apps/soft/kubernetes/bin:$PATH
echo 'export PATH=/apps/soft/kubernetes/bin:$PATH' >> /etc/profile

# specify vip
kubectl config set-cluster kubernetes --certificate-authority=/etc/kubernetes/ssl/ca.pem --embed-certs=true --server=https://$VIP:6443
kubectl config set-credentials admin --client-certificate=/etc/kubernetes/ssl/admin.pem --embed-certs=true --client-key=/etc/kubernetes/ssl/admin-key.pem
kubectl config set-context kubernetes --cluster=kubernetes --user=admin
kubectl config use-context kubernetes



BOOTSTRAP_TOKEN="$( head -c 16 /dev/urandom | od -An -t x | tr -d ' ' )"

cat > token.csv <<eof
$BOOTSTRAP_TOKEN,kubelet-bootstrap,10001,"system:kubelet-bootstrap"
eof

kubectl config set-cluster kubernetes --certificate-authority=/etc/kubernetes/ssl/ca.pem --embed-certs=true --server=https://$VIP:6443 --kubeconfig=bootstrap.kubeconfig
kubectl config set-credentials kubelet-bootstrap --token=$BOOTSTRAP_TOKEN --kubeconfig=bootstrap.kubeconfig
kubectl config set-context default --cluster=kubernetes --user=kubelet-bootstrap --kubeconfig=bootstrap.kubeconfig
kubectl config use-context default --kubeconfig=bootstrap.kubeconfig



kubectl config set-cluster kubernetes --certificate-authority=/etc/kubernetes/ssl/ca.pem --embed-certs=true --server=https://$VIP:6443 --kubeconfig=kube-proxy.kubeconfig
kubectl config set-credentials kube-proxy --client-certificate=/etc/kubernetes/ssl/kubeproxy.pem --client-key=/etc/kubernetes/ssl/kube-proxy-key.pem --embed-certs=true --kubeconfig=kube-proxy.kubeconfig
kubectl config set-context default --cluster=kubernetes --user=kube-proxy --kubeconfig=kube-proxy.kubeconfig
kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

cp -f bootstrap.kubeconfig kube-proxy.kubeconfig token.csv /etc/kubernetes/


echo "starting create system service..."

# kube-apiserver
# kube-scheduler
# kube-controller-manager

cat >/etc/systemd/system/kube-apiserver.service<<eof
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
User=root
ExecStart=/apps/soft/kubernetes/bin/kube-apiserver \\
  --admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
  --advertise-address=$VIP \\
  --allow-privileged=true \\
  --apiserver-count=1 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=/apps/logs/kubernetes/audit.log \\
  --authorization-mode=RBAC \\
  --bind-address=$IP \\
  --client-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --enable-swagger-ui=true \\
  --etcd-cafile=/etc/kubernetes/ssl/ca.pem \\
  --etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem \\
  --etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem \\
  --etcd-servers=$ETCD_ENDPOINTS \\
  --event-ttl=12h \\
  --kubelet-https=true \\
  --insecure-bind-address=127.0.0.1 \\
  --runtime-config=rbac.authorization.k8s.io/v1alpha1 \\
  --service-account-key-file=/etc/kubernetes/ssl/ca-key.pem \\
  --service-cluster-ip-range=$SERVICE_CIDR \\
  --service-node-port-range=$NODE_PORT_RANGE \\
  --tls-cert-file=/etc/kubernetes/ssl/kubernetes.pem \\
  --tls-private-key-file=/etc/kubernetes/ssl/kubernetes-key.pem \\
  --experimental-bootstrap-token-auth \\
  --token-auth-file=/etc/kubernetes/token.csv \\
  --event-ttl=12h0m0s \\
  --v=2
Restart=on-failure
RestartSec=5
Type=notify
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
eof

systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver
systemctl status kube-apiserver


cat >/etc/systemd/system/kube-controller-manager.service<<eof
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/apps/soft/kubernetes/bin/kube-controller-manager \\
  --address=127.0.0.1 \\
  --allocate-node-cidrs=true \\
  --cluster-cidr=$CLUSTER_CIDR \\
  --cluster-name=kubernetes \\
  --cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem \\
  --cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem \\
  --leader-elect=true \\
  --master=http://127.0.0.1:8080 \\
  --root-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem \\
  --service-cluster-ip-range=$SERVICE_CIDR \\
  --pod-eviction-timeout=1m0s \\
  --v=5
Restart=on-failure
RestartSec=5
#Type=notify

[Install]
WantedBy=multi-user.target
eof

systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager
systemctl status kube-controller-manager


cat >/etc/systemd/system/kube-scheduler.service<<eof
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/apps/soft/kubernetes/bin/kube-scheduler \\
  --leader-elect=true \\
  --master=http://127.0.0.1:8080 \\
  --address=127.0.0.1 \\
  --v=5
Restart=on-failure
RestartSec=5
#Type=notify

[Install]
WantedBy=multi-user.target
eof

systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler
systemctl status kube-scheduler


