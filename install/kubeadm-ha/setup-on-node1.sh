
wget -q fs.qianbao-inc.com/k8s/kubeadm-ha/cfssl -O /usr/local/bin/cfssl
wget -q fs.qianbao-inc.com/k8s/kubeadm-ha/cfssljson -O /usr/local/bin/cfssljson 
chmod +x /usr/local/bin/cfssl*

mkdir -p /etc/etcd
cd /etc/etcd

cat >ca-config.json <<EOF
 {
    "signing": {
        "default": {
            "expiry": "43800h"
        },
        "profiles": {
            "server": {
                "expiry": "43800h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            },
            "client": {
                "expiry": "43800h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "43800h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
 }
EOF

cat >ca-csr.json <<EOF
 {
    "CN": "etcd",
    "key": {
        "algo": "rsa",
        "size": 2048
    }
 }
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca -

cat >client.json <<EOF
{
  "CN": "client",
  "key": {
      "algo": "ecdsa",
      "size": 256
  }
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client client.json | cfssljson -bare client


curl fs.qianbao-inc.com/k8s/kubeadm-ha/cert/uploadapi -F truancate=yes -F file=@ca.pem
curl fs.qianbao-inc.com/k8s/kubeadm-ha/cert/uploadapi -F truancate=yes -F file=@ca-key.pem
curl fs.qianbao-inc.com/k8s/kubeadm-ha/cert/uploadapi -F truancate=yes -F file=@client.pem
curl fs.qianbao-inc.com/k8s/kubeadm-ha/cert/uploadapi -F truancate=yes -F file=@client-key.pem
curl fs.qianbao-inc.com/k8s/kubeadm-ha/cert/uploadapi -F truancate=yes -F file=@ca-config.json

