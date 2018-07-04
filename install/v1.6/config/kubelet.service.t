[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/apps/soft/kubernetes/lib/kubelet
ExecStart=/apps/soft/kubernetes/bin/kubelet \
  --address=IP \
  --hostname-override=IP \
  --pod-infra-container-image=reg.qianbao-inc.com/base/pod-infrastructure:latest \
  --experimental-bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig \
  --kubeconfig=/etc/kubernetes/kubelet-kubeconfig \
  --require-kubeconfig \
  --cert-dir=/etc/kubernetes/ssl \
  --container-runtime=docker \
  --cluster_dns=10.254.0.2 \
  --cluster_domain=cluster.local. \
  --hairpin-mode promiscuous-bridge \
  --allow-privileged=true \
  --serialize-image-pulls=false \
  --register-node=true \
  --logtostderr=true \
  --kube-reserved=memory=1Gi \
  --v=5
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
