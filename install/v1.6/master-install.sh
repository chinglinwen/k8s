#!/bin/sh
# master install

# keepalived and haproxy

yum -y install keepalived haproxy
systemctl enable keepalived
systemctl enable haproxy
echo 'net.ipv4.ip_nonlocal_bind = 1'>>/etc/sysctl.conf
sysctl -p

download 

/etc/keepalived/keepalived.conf
/etc/haproxy/check_haproxy.sh

cat > /etc/haproxy/check_haproxy.sh <<EOF
#!/bin/bash
if [ \$(ps -C haproxy --no-header | wc -l) -eq 0 ]; then
systemctl start haproxy
exit 1
fi
EOF
chmod 755 /etc/haproxy/check_haproxy.sh

# haproxy
cat /etc/kubernetes/ssl/admin.pem /etc/kubernetes/ssl/admin-key.pem
>/etc/kubernetes/ssl/k8s-admin.crt

/etc/systemd/system/haproxy.service

/etc/haproxy/haproxy.cfg


/etc/rsyslog.d/haproxy.conf

sed -i -e 's/SYSLOGD_OPTIONS=""/SYSLOGD_OPTIONS="-r -m 0 -c 2"/'
/etc/sysconfig/rsyslog
sed -i -e 's/syslogd.pid/rsyslogd.pid/' /etc/logrotate.d/syslog
systemctl restart rsyslog
  //no this

systemctl start haproxy
systemctl enable haproxy
systemctl start keepalived
systemctl enable keepalived


cp ca.pem kubernetes-key.pem kubernetes.pem /etc/kubernetes/ssl


wget https://dl.k8s.io/v1.6.13/kubernetes-client-linux-amd64.tar.gz
tar -zxf kubernetes-client-linux-amd64.tar.gz
cp kubernetes/client /apps/soft/kubernetes -rf
export PATH=/apps/soft/kubernetes/bin:$PATH

# specify vip
kubectl config set-cluster kubernetes --certificate-authority=/etc/kubernetes/ssl/ca.pem --
embed-certs=true --server=https://10.66.8.201:6443
kubectl config set-credentials admin --client-certificate=/etc/kubernetes/ssl/admin.pem --
embed-certs=true --client-key=/etc/kubernetes/ssl/admin-key.pem
kubectl config set-context kubernetes --cluster=kubernetes --user=admin
kubectl config use-context kubernetes



BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')

cat > token.csv <<EOF
11c15d659e66635a09727acb05955749,kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF

kubectl config set-cluster kubernetes --certificate-authority=/etc/kubernetes/ssl/ca.pem --
embed-certs=true --server=https://10.66.8.201:6443 --kubeconfig=bootstrap.kubeconfig
kubectl config set-credentials kubelet-bootstrap --
token=11c15d659e66635a09727acb05955749 --kubeconfig=bootstrap.kubeconfig
kubectl config set-context default --cluster=kubernetes --user=kubelet-bootstrap --
kubeconfig=bootstrap.kubeconfig
kubectl config use-context default --kubeconfig=bootstrap.kubeconfig



kubectl config set-cluster kubernetes --certificate-authority=/etc/kubernetes/ssl/ca.pem --
embed-certs=true --server=https://10.66.8.201:6443 --kubeconfig=kube-proxy.kubeconfig
kubectl config set-credentials kube-proxy --client-certificate=/etc/kubernetes/ssl/kubeproxy.
pem --client-key=/etc/kubernetes/ssl/kube-proxy-key.pem --embed-certs=true --
kubeconfig=kube-proxy.kubeconfig
kubectl config set-context default --cluster=kubernetes --user=kube-proxy --
kubeconfig=kube-proxy.kubeconfig
kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig


cp bootstrap.kubeconfig kube-proxy.kubeconfig token.csv /etc/kubernetes/



# master
wget https://dl.k8s.io/v1.6.13/kubernetes-server-linux-amd64.tar.gz
tar -zxf kubernetes-server-linux-amd64.tar.gz
cp kubernetes/server /apps/soft/kubernetes -rf
export PATH=/apps/soft/kubernetes/bin:$PATH
echo 'export PATH=/apps/soft/kubernetes/bin:$PATH' >> /etc/profile

cp bootstrap.kubeconfig kube-proxy.kubeconfig token.csv /etc/kubernetes/



/etc/systemd/system/kube-apiserver.service

systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver
systemctl status kube-apiserver


/etc/systemd/system/kube-controller-manager.service

systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager


/etc/systemd/system/kube-scheduler.service

systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler



# kube-apiserver
# kube-scheduler
# kube-controller-manager
