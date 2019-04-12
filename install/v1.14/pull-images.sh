#!/bin/sh
# pull all needed images

cnt="$( docker images | grep gcr | wc | awk '{ print $1 }' )"
if [ $cnt -eq 7 ]; then
  echo "already pulled, exit"
  exit
fi

while read l; do
  if [ "x$l" = "x" ]; then
    continue
  fi
  img="$l"
  newimg="$( echo $img | sed 's/\//-/g' )"
  newtag="chinglinwen/$newimg"
  echo "$img -> $newtag"
  docker pull $newtag
  docker tag  $newtag $img
  docker rmi $newtag
  echo "$newtag done"
done <<eof
k8s.gcr.io/kube-apiserver:v1.14.1
k8s.gcr.io/kube-controller-manager:v1.14.1
k8s.gcr.io/kube-scheduler:v1.14.1
k8s.gcr.io/kube-proxy:v1.14.1
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.3.10
k8s.gcr.io/coredns:1.3.1
eof
