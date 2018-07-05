#!/bin/sh
. ./env

# create cert

# tool install

cfssl_install () {
  which cfssl >/dev/null || \
  wget -O /usr/local/bin/cfssl http://fs.qianbao-inc.com/k8s/install/v1.6/tools/cfssl; chmod +x /usr/local/bin/cfssl
  which cfssljson >/dev/null || \
  wget -O /usr/local/bin/cfssljson http://fs.qianbao-inc.com/k8s/install/v1.6/tools/cfssljson; chmod +x /usr/local/bin/cfssljson
  echo "cfssl and cfssljson ok"
}
cfssl_install

sslbase=/tmp/ssl
mkdir $sslbase; cd $sslbase

cfssl print-defaults config > config.json
cfssl print-defaults csr > csr.json

cat >ca-config.json<<EOF
{
"signing": {
"default": {
"expiry": "87600h"
},
"profiles": {
"kubernetes": {
"usages": [
"signing",
"key encipherment",
"server auth",
"client auth"
],
"expiry": "87600h"
}
}
}
}
EOF

cat> ca-csr.json <<EOF
{
"CN": "kubernetes",
"key": {
"algo": "rsa",
"size": 2048
},
"names": [
{
"C": "CN",
"ST": "BeiJing",
"L": "BeiJing",
"O": "k8s",
"OU": "System"
}
]
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca


cat >kubernetes-csr.json<<EOF
{
"CN": "kubernetes",
"hosts": [
"127.0.0.1",
$HOSTS
"10.254.0.1",
"kubernetes",
"kubernetes.default",
"kubernetes.default.svc",
"kubernetes.default.svc.cluster",
"kubernetes.default.svc.cluster.local"
],
"key": {
"algo": "rsa",
"size": 2048
},
"names": [
{
"C": "CN",
"ST": "BeiJing",
"L": "BeiJing",
"O": "k8s",
"OU": "System"
}
]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes

cat >admin-csr.json<<EOF
{
"CN": "admin",
"hosts": [],
"key": {
"algo": "rsa",
"size": 2048
},
"names": [
{
"C": "CN",
"ST": "BeiJing",
"L": "BeiJing",
"O": "system:masters",
"OU": "System"
}
]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin


cat >kube-proxy-csr.json <<EOF
{
"CN": "system:kube-proxy",
"hosts": [],
"key": {
"algo": "rsa",
"size": 2048
},
"names": [
{
"C": "CN",
"ST": "BeiJing",
"L": "BeiJing",
"O": "k8s",
"OU": "System"
}
]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-proxy-csr.json | cfssljson -bare kube-proxy

mkdir -p /etc/kubernetes/ssl
cp $sslbase/* /etc/kubernetes/ssl


cd -
. $BASE/remote-exec.sh

echo 'mkdir -p /etc/kubernetes/ssl' > /tmp/mkdir.sh
ea /tmp/mkdir.sh
doscp '/etc/kubernetes/ssl/*.pem' /etc/kubernetes/ssl/

rm -f /tmp/mkdir.sh
