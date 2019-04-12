#!/bin/sh
# install etcd, assume running on host0
# pre-requiresite: kubeadm and docker is installed

# refer: https://kubernetes.io/docs/setup/independent/setup-ha-etcd-with-kubeadm/

# on host0

# Update HOST0, HOST1, and HOST2 with the IPs or resolvable names of your hosts
export HOST0=172.31.90.100
export HOST1=172.31.90.101
export HOST2=172.31.90.102

# Create temp directories to store files that will end up on other hosts.
mkdir -p /tmp/${HOST0}/ /tmp/${HOST1}/ /tmp/${HOST2}/

ETCDHOSTS=(${HOST0} ${HOST1} ${HOST2})
NAMES=("infra0" "infra1" "infra2")

for i in "${!ETCDHOSTS[@]}"; do
HOST=${ETCDHOSTS[$i]}
NAME=${NAMES[$i]}
cat << EOF > /tmp/${HOST}/kubeadmcfg.yaml
apiVersion: "kubeadm.k8s.io/v1beta1"
kind: ClusterConfiguration
etcd:
    local:
        serverCertSANs:
        - "${HOST}"
        peerCertSANs:
        - "${HOST}"
        extraArgs:
            initial-cluster: ${NAMES[0]}=https://${ETCDHOSTS[0]}:2380,${NAMES[1]}=https://${ETCDHOSTS[1]}:2380,${NAMES[2]}=https://${ETCDHOSTS[2]}:2380
            initial-cluster-state: new
            name: ${NAME}
            listen-peer-urls: https://${HOST}:2380
            listen-client-urls: https://${HOST}:2379
            advertise-client-urls: https://${HOST}:2379
            initial-advertise-peer-urls: https://${HOST}:2380
EOF
done

# Create etcd cert /etc/kubernetes/pki/etcd/ca.{crt,key}
kubeadm init phase certs etcd-ca

# Create certificates for each member
kubeadm init phase certs etcd-server --config=/tmp/${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=/tmp/${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST2}/kubeadmcfg.yaml
cp -R /etc/kubernetes/pki /tmp/${HOST2}/
# cleanup non-reusable certificates
find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

kubeadm init phase certs etcd-server --config=/tmp/${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=/tmp/${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST1}/kubeadmcfg.yaml
cp -R /etc/kubernetes/pki /tmp/${HOST1}/
find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

kubeadm init phase certs etcd-server --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST0}/kubeadmcfg.yaml
# No need to move the certs because they are for HOST0
cp -R /etc/kubernetes/pki /tmp/${HOST0}/  # let's still do a backup

# clean up certs that should not be copied off this host
find /tmp/${HOST2} -name ca.key -type f -delete
find /tmp/${HOST1} -name ca.key -type f -delete

cd /tmp
tar -czf $HOST0.tar.gz $HOST0
tar -czf $HOST1.tar.gz $HOST1
tar -czf $HOST2.tar.gz $HOST2

curl http://fs.devops.haodai.net/k8s/v1.14/cert/uploadapi -F file=@$HOST0.tar.gz -F truncate=yes
curl http://fs.devops.haodai.net/k8s/v1.14/cert/uploadapi -F file=@$HOST1.tar.gz -F truncate=yes
curl http://fs.devops.haodai.net/k8s/v1.14/cert/uploadapi -F file=@$HOST2.tar.gz -F truncate=yes

# on host2
cd /tmp
wget http://fs.devops.haodai.net/k8s/v1.14/cert/172.31.90.102.tar.gz
tar -xzf 172.31.90.102.tar.gz
mv 172.31.90.102/pki /etc/kubernetes
cd
yum install tree -y
tree /etc/kubernetes

# on host1
cd /tmp
wget http://fs.devops.haodai.net/k8s/v1.14/cert/172.31.90.101.tar.gz
tar -xzf 172.31.90.101.tar.gz
mv 172.31.90.101/pki /etc/kubernetes
cd
yum install tree -y
tree /etc/kubernetes

# host0 no need action

# start creat maninfest

# on host0
kubeadm init phase etcd local --config=/tmp/172.31.90.100/kubeadmcfg.yaml

# on host1
kubeadm init phase etcd local --config=/tmp/172.31.90.101/kubeadmcfg.yaml

# on host2
kubeadm init phase etcd local --config=/tmp/172.31.90.102/kubeadmcfg.yaml



# execute on all etcd nodes

mkdir -p /etc/systemd/system/kubelet.service.d
cat << EOF > /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
ExecStart=/usr/bin/kubelet --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true  --root-dir=/data/kubelet --cgroup-driver=systemd
Restart=always
EOF

systemctl daemon-reload
systemctl restart kubelet

# on host0

# check etcd health status
etcdimg="$( grep image: /etc/kubernetes/manifests/etcd.yaml  | awk '{ print $2 }' FS=': ' )"
docker run --rm -it \
--net host \
-v /etc/kubernetes:/etc/kubernetes $etcdimg etcdctl \
--cert-file /etc/kubernetes/pki/etcd/peer.crt \
--key-file /etc/kubernetes/pki/etcd/peer.key \
--ca-file /etc/kubernetes/pki/etcd/ca.crt \
--endpoints https://${HOST0}:2379 cluster-health