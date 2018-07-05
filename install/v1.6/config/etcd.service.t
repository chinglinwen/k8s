[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
Type=notify
WorkingDirectory=/apps/soft/etcd/var/
EnvironmentFile=-/etc/etcd/etcd.conf
ExecStart=/apps/soft/etcd/bin/etcd \
  --name=etcd-$SUFFIX \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  --peer-cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --peer-key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  --trusted-ca-file=/etc/kubernetes/ssl/ca.pem \
  --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem \
  --initial-advertise-peer-urls=https://$IP:2380 \
  --listen-peer-urls=https://$IP:2380 \
  --listen-client-urls=https://$IP:2379,http://127.0.0.1:2379 \
  --advertise-client-urls=https://$IP:2379 \
  --initial-cluster-token=etcd-cluster-0 \
  --initial-cluster=etcd-$SUFFIX1=https://$ETCD1:2380,etcd-$SUFFIX2=https://$ETCD2:2380,etcd-$SUFFIX3=https://$ETCD3:2380 \
  --initial-cluster-state=new \
  --data-dir=/apps/soft/etcd/var/
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
