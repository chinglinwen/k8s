#!/bin/sh

convertback () {
  img="$1"
  newimg="$( echo $img | sed 's/k8s.gcr.io/reg.qianbao-inc.com\/k8s/g' )"
  echo "$img -> $newimg"
  docker pull $newimg
  docker tag $newimg $img
  docker rmi $newimg
  echo "$newimg done"
}


#masters
while read l; do
  convertback  $l
done <<eof
k8s.gcr.io/kube-controller-manager-amd64:v1.10.2
k8s.gcr.io/kube-apiserver-amd64:v1.10.2
k8s.gcr.io/kube-proxy-amd64:v1.10.2
k8s.gcr.io/kube-scheduler-amd64:v1.10.2
k8s.gcr.io/etcd-amd64:3.1.12
k8s.gcr.io/pause-amd64:3.1
eof

#nodes back
while read l; do
  convertback $l
done <<eof
k8s.gcr.io/pause-amd64:3.1
k8s.gcr.io/kube-proxy-amd64:v1.10.2
k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.3
k8s.gcr.io/heapster-influxdb-amd64:v1.3.3
k8s.gcr.io/heapster-grafana-amd64:v4.4.3
k8s.gcr.io/heapster-amd64:v1.5.3
eof

