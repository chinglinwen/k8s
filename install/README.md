# Kubernetes install

## install docker

./remote-exec.sh ./docker/install.sh

## install kubeadm tools

./remote-exec.sh ./kubeadmtools.sh

## install kubernetes

cd kubeadm
./install.sh

> 更多信息见 [kubeadm](kubeadm)

> 多master见 [kubeadm-ha](kubeadm-ha) ( not ready )