#!/bin/sh
# others, kube-dns etc

kubedns-svc.yaml

diff kubedns-svc.yaml.base kubedns-svc.yaml

diff kubedns-controller.yaml.base kubedns-controller.yaml

# 部署kubedns pods
# 进入install_kubernetes_yaml/kube-dns的yaml目录
kubectl create -f .

# 进入install_kubernetes_yaml/dashboard的yaml目录
# 此部分使用diff对比两个配置文件的修改部分
diff dashboard-service.yaml.orig dashboard-service.yaml


# 进入install_kubernetes_yaml/dashboard的yaml目录
kubectl create -f .

kubectl cluster-info


http://172.28.40.76:8080/api/v1/proxy/namespaces/kubesystem/
services/kubernetes-dashboard


# 部署监控
# 进入install_kubernetes_yaml目录的heapster下
# 部署grafana
# 如果后续使用 kube-apiserver 或者 kubectl proxy 访问 grafana dashboard，
# +则必须将 GF_SERVER_ROOT_URL 设置为
/api/v1/proxy/namespaces/kubesystem/services/monitoring-grafana/ ，
# +否则后续访问grafana时访问时提示找不到
# +http://10.64.3.7:8086/api/v1/proxy/namespaces/kubesystem/services/monitoringgrafana/
api/dashboards/home 页面；
# value: /api/v1/proxy/namespaces/kube-system/services



# 部署heapstr
# heapster.yaml
# 在template下的spec下添加：
# serviceAccountName: heapster
# config.toml文件需要修改
# enabled = true
# influxdb 部署
# 进入install_kubernetes_yaml目录的heapster下
# 修改influxdb.yaml文件
# 在 volumeMounts添加如下：
# volumeMounts:
# - mountPath: /etc/
# name: influxdb-config
# 在 volumes 添加如下：
# volumes:
# - name: influxdb-config
# configMap:
# name: influxdb-config
# 部署ingress
# 生成私有的d.k8s.me证书，用于dashboard
# 生成 CA 自签证书
mkdir cert && cd cert
openssl genrsa -out ca-key.pem 2048
openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kubeca"
# 编辑 openssl 配置
cp /etc/pki/tls/openssl.cnf .
vim openssl.cnf

# 主要修改如下
[req]
req_extensions = v3_req # 这行默认注释关着的 把注释删掉
# 下面配置是新增的
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = d.k8s.me
#DNS.2 = kibana.mritd.me
# 生成证书
openssl genrsa -out ingress-key.pem 2048
openssl req -new -key ingress-key.pem -out ingress.csr -subj "/CN=d.k8s.me" -config
openssl.cnf
openssl x509 -req -in ingress.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out
ingress.pem -days 365 -extensions v3_req -extfile openssl.cnf
# 创建secret
kubectl create secret tls d.k8s.me-secret --namespace=kube-system --key cert/ingresskey.
pem --cert cert/ingress.pem
# 安装ingress
# 进入/root/install_kubernetes_yaml/ingress
kubectl create -f .
# 访问dashboard的ingress
https://d.k8s.me
# 安装自研的watch服务
# 下载Wukong的代码到/apps/目录
# 复制ENV27的virtualENV环境到/usr/src下
# 安装supervisor
/usr/src/ENV27/bin/pip install supervisor==3.3.1


# 配置watch的supervisird
[group:wukong]
programs=wukong_watch
[program:wukong_watch]
command=/usr/src/ENV27/bin/python2.7
/apps/WuKong/src/wk_server/celery_wk/cluster_watch_nginx.py
user=root
startretries=300
autorestart=true
logfile=/apps/soft/supervisird/log/wukong/wukong_watch.log
stdout_logfile=/apps/soft/supervisird/log/wukong/wukong_watch.log
stderr_logfile=/apps/soft/supervisird/log/wukong/wukong_watch.err
# 启动
/usr/src/ENV27/bin/python2.7 /usr/src/ENV27/bin/supervisord
# 添加自启动
echo '/usr/src/ENV27/bin/python2.7 /usr/src/ENV27/bin/supervisord' >> /etc/rc.d/rc.local
