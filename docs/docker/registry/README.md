# Harbor

## 域名
目前域名直接指向对应的harbor ip地址，不走复制（base的复制保留）

## 生产环境

https://harbor.wk.qianbao-inc.com/

ip: 10.66.0.13

> 注：由于网络的限制（生产环境不能访问测试harbor）

## 测试环境

https://harbor-test.wk.qianbao-inc.com

ip: 172.28.40.90


## Jenkins

镜像build服务器: 172.28.49.91

## docker config

```
sed -i 's/INSECURE_REGISTRY=.*/INSECURE_REGISTRY="--insecure-registry harbor.wk.qianbao-inc.com --insecure-registry harbor-test.wk.qianbao-inc.com"/' /etc/sysconfig/docker
systemctl restart docker
```

## Example usage

```
docker pull harbor.wk.qianbao-inc.com/k8s/hello
docker pull harbor-test.wk.qianbao-inc.com/k8s/hello
```

```
[root@bjdfkjy-46-123 k8s]# docker pull harbor.wk.qianbao-inc.com/k8s/hello
Using default tag: latest
latest: Pulling from k8s/hello
Digest: sha256:48b69107095fc23bf6a4e61b0bd11f9843bf4f0e8bf4033fc3b6742b066b756e
Status: Downloaded newer image for harbor.wk.qianbao-inc.com/k8s/hello:latest
[root@bjdfkjy-46-123 k8s]# docker pull harbor-test.wk.qianbao-inc.com/k8s/hello
Using default tag: latest
latest: Pulling from k8s/hello
Digest: sha256:48b69107095fc23bf6a4e61b0bd11f9843bf4f0e8bf4033fc3b6742b066b756e
Status: Image is up to date for harbor-test.wk.qianbao-inc.com/k8s/hello:latest
[root@bjdfkjy-46-123 k8s]# 
```
