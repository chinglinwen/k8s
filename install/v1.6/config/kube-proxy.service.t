[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/apps/soft/kubernetes/bin/kube-proxy \
  --bind-address=IP \
  --cluster-cidr=10.254.0.0/16 \
   --hostname-override=IP \
  --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig \
  --logtostderr=true \
  #--log-dir=/var/log/kubernetes/ \
  --v=5
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
