# Docker 17.06.2 version install

Match for pro-env version

install for docker build machine, or normal docker use etc ( it's not a k8s docker version )


## Update kernel to use overlay2 driver

from 3.10.0 -> 4.4.105

```
curl http://issue.qianbao-inc.com/SRE/k8s/raw/branch/master/install/docker-v17.06.2/kernel.sh | sh
```

> it will reboot the server

## Install docker

```
curl http://issue.qianbao-inc.com/SRE/k8s/raw/branch/master/install/docker-v17.06.2/install.sh | sh
```
