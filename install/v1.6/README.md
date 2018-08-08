# k8s v1.6 install

## setup info
vi env

ENV=env ./prepare.sh

> it will use fs.qianbao-inc.com service, software download etc.

## setup remote ssh without password

copy id_rsa.pub to all server ( master and nodes )

## create cert

```
./cert-create.sh
```

## install etcd

```
. ./remote-exec.sh
ee etcd-install.sh
```

if cert change, need restart etcd.

## install masters

```
./master-install.sh
```

## install nodes ( ovs, docker, kubelet and kube-proxy )

```
node-install.sh
```

> docker may change route, it may make server unreachable. 
> 
> make sure info is correct, otherwise may need manage console to login.


Reference docs: [独立部署v1.6.pdf](/docs/install/kubernetes 独立部署v1.6.pdf) by xigui