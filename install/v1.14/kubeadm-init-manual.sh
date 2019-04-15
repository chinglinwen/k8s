#!/bin/sh
# deploy k8s 

# refer: https://kubernetes.io/docs/setup/independent/high-availability/
# with External etcd nodes

# setup ha ( an keepalived will do, it will create ipvs entry )

# refer: https://kubernetes.io/docs/setup/independent/high-availability/#external-etcd-nodes

# setup load balance
# Make sure the address of the load balancer always matches the address of kubeadm?s ControlPlaneEndpoint.

# https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

# etcd:
#     external:
#         endpoints:
#         - https://172.31.90.100:2379
#         - https://172.31.90.101:2379
#         - https://172.31.90.102:2379
#         caFile: /etc/kubernetes/pki/etcd/ca.crt
#         certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
#         keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key

cat > kubeadm-config.yaml <<eof
apiVersion: kubeadm.k8s.io/v1beta1
kind: ClusterConfiguration
kubernetesVersion: v1.14.1
controlPlaneEndpoint: "172.31.90.219:6443"
apiServer:
  certSANs:
  - "172.31.90.100"
  - "172.31.90.101"
  - "172.31.90.102"
  extraArgs:
    enable-admission-plugins: PodPreset,Priority,StorageObjectInUseProtection,NodeRestriction
    service-node-port-range: "80-65535"
    advertise-address: "0.0.0.0"
    #insecure-bind-address: "0.0.0.0"
    insecure-port: "8080"
networking:
  podSubnet: "10.1.1.0/20"
#imageRepository: registry.cn-hangzhou.aliyuncs.com/google_containers
dns:
  type: CoreDNS
etcd:
  local:
    dataDir: /data/etcd
eof

# retry
# systemctl stop kubelet
# rm -rf /etc/kubernetes/manifests/kube-*
# rm -rf /var/lib/etcd
# kubeadm reset

# rm -f /var/lib/kubelet/config.yaml
# rm -f /var/lib/kubelet/kubeadm-flags.env

# save output for, other master to join
IP="$( ip addr show `ip r |grep default | awk '{ print $5 }'` | grep link -A 1 | grep -Po 'inet \K[\d.]+' )"
kubeadm init --config kubeadm-config.yaml --experimental-upload-certs --node-name $IP | tee kubeadm.out


# cni setting

# https://github.com/cloudnativelabs/kube-router/blob/master/docs/kubeadm.md
# must specify --pod-network-cidr when you run kubeadm init.

wget https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter-all-features.yaml
KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f kubeadm-kuberouter-all-features.yaml


# remove kube-proxy and cleanup any iptables configuration it may have done.
KUBECONFIG=/etc/kubernetes/admin.conf kubectl -n kube-system delete ds kube-proxy

# proxyimage="$( docker images | grep proxy | awk '{ print $1,$2 }' OFS=':' )"
# docker run --privileged -v /lib/modules:/lib/modules --net=host $proxyimage kube-proxy --cleanup


# test 
# nc -v 172.31.90.219 6443
# curl -k https://172.31.90.219:6443/api/v1/namespaces/kube-public/configmaps/cluster-info

# keepalived set for first master only, later change to cover three master

# join master
IP="$( ip addr show `ip r |grep default | awk '{ print $5 }'` | grep link -A 1 | grep -Po 'inet \K[\d.]+' )"
kubeadm join 172.31.90.219:6443 --token w0dn8y.d2ih2dlfsstcm9bc \
    --discovery-token-ca-cert-hash sha256:90143f348f7a74bf0c2d696fce1c0a9ec9ae9284e77d850fbc3d9a907b2263bf \
    --experimental-control-plane --certificate-key df41aec2cea9e2757d9ddef73e5bee078d8a1600b12a5579ccc83d055ff153c8 --node-name $IP -v 5

# join node
IP="$( ip addr show `ip r |grep default | awk '{ print $5 }'` | grep link -A 1 | grep -Po 'inet \K[\d.]+' )"
kubeadm join 172.31.90.219:6443 --token w0dn8y.d2ih2dlfsstcm9bc \
    --discovery-token-ca-cert-hash sha256:90143f348f7a74bf0c2d696fce1c0a9ec9ae9284e77d850fbc3d9a907b2263bf --node-name $IP


# Make sure the first control plane node is fully initialized.

# Join each control plane node with the join command you saved to a text file. 
# It?s recommended to join the control plane nodes one at a time.

# node join

# dashboard

wget https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
sed -i 's/k8s.gcr.io/chinglinwen/' kubernetes-dashboard.yaml
sed -i 's/auto-generate-certificates/auto-generate-certificates\n          - --token-ttl=0/' kubernetes-dashboard.yaml
kubectl apply -f kubernetes-dashboard.yaml

#create sample user

kubectl apply -f - <<eof
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
eof
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

kubectl apply -f - <<eof
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 10000
  selector:
    k8s-app: kubernetes-dashboard
  type: NodePort
eof