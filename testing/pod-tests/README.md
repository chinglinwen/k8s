# pod-tests
## 测试内容

1. 单节点最大pod数
1. 集群最大pod数

## 测试准备

所有节点提前pull相关镜像

```
docker pull reg.qianbao-inc.com/k8s/mmm-master:latest
docker pull reg.qianbao-inc.com/k8s/mmm-minion:latest
docker pull reg.qianbao-inc.com/k8s/mmm-mariadb:latest
```

指定资源(limit setting)

```
limit cpu,2,memory: 1G
requests: memory: 1G
```

一个deployment对应一个pod

## 测试方法

### single node ( with limit )

```
./kubectl_mon.py &> single-node-deploy-limit.out &
RESOURCE="#" N=100 ./start.sh 
kubectl get pods -n minions -o wide|grep minion|grep Run|wc
```

#### single node

```
./kubectl_mon.py &> single-node-deploy.out &
RESOURCE="#" N=100 ./start.sh 
kubectl get pods -n minions -o wide|grep minion|grep Run|wc
```

### all nodes ( with limit )

```
./kubectl_mon.py &> all-nodes-deploy-limit.out &
N=50 ./start.sh
kubectl get pods -n minions -o wide|grep minion|grep Run|wc
```

### all nodes

```
./kubectl_mon.py &> all-nodes-deploy.out &
RESOURCE="#" N=300 ALLNODES=true ./start.sh
kubectl get pods -n minions -o wide|grep minion|grep Run|wc 
```

## 测试结果

> 预计所需安装

```
sudo pip install numpy
sudo pip install --upgrade pip
sudo pip install matplotlib
sudo yum install tkinter -y
```

```
./generate-png.sh test-env/
```

生成与out对应的png文件

## 参考

1. https://docs.openstack.org/developer/performance-docs/test_plans/kubernetes_density/plan.html
