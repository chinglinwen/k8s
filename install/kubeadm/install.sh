#!/bin/sh

# assume docker is ready on every node
./precheck.sh
if [ $? -ne 0 ]; then
  echo "precheck failed. exit"
  exit 1
fi

# install kubeadm kubelet kubectl
curl -s http://fs.qianbao-inc.com/k8s/kubeadm/install.sh | sh

cat >kubeadm.conf <<eof
apiVersion: kubeadm.k8s.io/v1alpha1
kind: MasterConfiguration
kubernetesVersion: v1.10.2
networking:
  podSubnet: "172.28.232.0/21"
apiServerExtraArgs:
  service-node-port-range: 80-32767
featureGates:
  CoreDNS: true
eof


kubeadm init --config=kubeadm.conf

cd ../../networking/kube-router/
./deploy.sh 
cd -

echo "wait dns ok..."

echo "do the join, as kubeadm outputs, append extra ignore-preflight-errors=cri, if something wrong"

echo "example: kubeadm join 172.28.46.2:6443 --token scjvzq.xy07jw57187994pc --discovery-token-ca-cert-hash sha256:802678f862efff912bb8a849d1562574a28f6762b5a42702a60214e805b4a3aa --ignore-preflight-errors=cri"
