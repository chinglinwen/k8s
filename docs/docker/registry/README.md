# Harbor

## 域名
目前域名直接指向对应的harbor ip地址

## 生产环境

https://pro-reg.qianbao-inc.com/

ip: 172.28.40.90

## 测试环境

https://reg.qianbao-inc.com

ip: 10.66.0.13

## Jenkins

镜像build服务器: 172.28.49.91

## docker config

```
sed -i 's/INSECURE_REGISTRY=.*/INSECURE_REGISTRY="--insecure-registry reg.qianbao-inc.com --insecure-registry pro-reg.qianbao-inc.com"/' /etc/sysconfig/docker
systemctl restart docker
```

## Example usage

```
docker pull reg.qianbao-inc.com/k8s/hello
docker pull pro-reg.qianbao-inc.com/k8s/hello
```

```
[root@dfkjyph01 ~]# docker pull reg.qianbao-inc.com/k8s/hello
Using default tag: latest

latest: Pulling from k8s/hello
Digest: sha256:48b69107095fc23bf6a4e61b0bd11f9843bf4f0e8bf4033fc3b6742b066b756e
Status: Image is up to date for reg.qianbao-inc.com/k8s/hello:latest

[root@dfkjyph01 ~]# docker pull pro-reg.qianbao-inc.com/k8s/hello
Using default tag: latest
latest: Pulling from k8s/hello
Digest: sha256:48b69107095fc23bf6a4e61b0bd11f9843bf4f0e8bf4033fc3b6742b066b756e
Status: Downloaded newer image for pro-reg.qianbao-inc.com/k8s/hello:latest
```
