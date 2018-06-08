

wget -N fs.qianbao-inc.com/k8s/kubeadm-ha/cfssl -O /usr/local/bin/cfssl
wget -N fs.qianbao-inc.com/k8s/kubeadm-ha/cfssljson -O /usr/local/bin/cfssljson 
chmod +x /usr/local/bin/cfssl*


mkdir -p /etc/etcd
cd /etc/etcd
wget -q fs.qianbao-inc.com/k8s/kubeadm-ha/cert/ca.pem
wget -q fs.qianbao-inc.com/k8s/kubeadm-ha/cert/ca-key.pem
wget -q fs.qianbao-inc.com/k8s/kubeadm-ha/cert/client.pem
wget -q fs.qianbao-inc.com/k8s/kubeadm-ha/cert/client-key.pem
wget -q fs.qianbao-inc.com/k8s/kubeadm-ha/cert/ca-config.json


