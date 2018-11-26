#!/bin/sh
# in case start error, ip may need dynamic change for specific environment.


rm -rf /var/lib/kube-router/kubeconfig
cat >> /var/lib/kube-router/kubeconfig<<eof
apiVersion: v1
kind: Config
clusters:
- name: cluster
  cluster:
    certificate-authority: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    server: https://172.28.46.2:6443
users:
- name: kube-router
  user:
    tokenFile: /var/run/secrets/kubernetes.io/serviceaccount/token
contexts:
- context:
    cluster: cluster
    user: kube-router
  name: kube-router-context
current-context: kube-router-context
eof
