#!/bin/sh

# assume docker is ready on every node
./precheck.sh
if [ $? -ne 0 ]; then
  echo "precheck failed. exit"
  exit 1
fi

cat<<eof
# install kubeadm kubelet kubectl on every node
curl -s http://fs.qianbao-inc.com/k8s/kubeadm/install.sh | sh
eof


echo "make sure image are already converted by docker ps"
# init
PRIVATE_IP="$( ip addr show `ip r |grep default | awk '{ print $NF }'` | grep -Po 'inet \K[\d.]+' )"
sed "s/PRIVATE_IP/$PRIVATE_IP/" kubeadm.conf > /tmp/kubeadm.conf
kubeadm init --config=/tmp/kubeadm.conf

  mkdir -p $HOME/.kube
  sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo
echo "installing... networks"
cd ../../networking/kube-router/
./deploy.sh 
cd -
kubectl -n kube-system delete ds kube-proxy

cat ./bridgeadd.txt

echo
echo "do the join on other nodes now, as kubeadm outputs"

echo "example: kubeadm join 172.28.46.2:6443 --token scjvzq.xy07jw57187994pc --discovery-token-ca-cert-hash sha256:802678f862efff912bb8a849d1562574a28f6762b5a42702a60214e805b4a3aa --ignore-preflight-errors=cri"

cat ./wait.txt

echo "installing... ui"
cd ../../ui/
./deploy.sh
cd -
