conduit install

curl https://run.conduit.io/install | bash
  # doesn't work
  # manual download it


kubectl get svc,deploy -n qb-pro fs -o yaml >fs.yaml

./conduit inject fs.yaml | kubectl apply -f -


[wen@pcmaster conduit]$ kubectl apply -f fs.yaml.injected 
deployment "fs" configured
The Service "fs" is invalid: 
* metadata.resourceVersion: Invalid value: "": must be specified for an update
* spec.clusterIP: Invalid value: "": field is immutable
[wen@pcmaster conduit]$



[wen@pcmaster conduit]$ ls
bak  conduit  conduit.yaml  conduit.yaml.bak  emojivoto.yml  emojivoto.yml.injected  fs.yaml  fs.yaml.injected  img.sed  install
[wen@pcmaster conduit]$ grep image: fs.yaml.injected 
      - image: reg.qianbao-inc.com/k8s-monitoring/fs
        image: gcr.io/runconduit/proxy:v0.3.1
        image: gcr.io/runconduit/proxy-init:v0.3.1
[wen@pcmaster conduit]$ sed -i img.sed fs.yaml.injected
[wen@pcmaster conduit]$ grep image: fs.yaml.injected 
      - image: reg.qianbao-inc.com/k8s-monitoring/fs
        image: gcr.io/runconduit/proxy:v0.3.1
        image: gcr.io/runconduit/proxy-init:v0.3.1
```        
[wen@pcmaster conduit]$ grep proxy img.sed 
s_gcr.io/runconduit/proxy-init:v0.3.1_chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1_
s_gcr.io/runconduit/proxy:v0.3.1_chinglinwen/gcr.io-runconduit-proxy:v0.3.1_
s_gcr.io/runconduit/proxy-init:v0.3.1_chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1_
s_gcr.io/runconduit/proxy:v0.3.1_chinglinwen/gcr.io-runconduit-proxy:v0.3.1_
s_gcr.io/runconduit/proxy-init:v0.3.1_chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1_
s_gcr.io/runconduit/proxy:v0.3.1_chinglinwen/gcr.io-runconduit-proxy:v0.3.1_
s_gcr.io/runconduit/proxy-init:v0.3.1_chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1_
s_gcr.io/runconduit/proxy:v0.3.1_chinglinwen/gcr.io-runconduit-proxy:v0.3.1_
s_gcr.io/runconduit/proxy-init:v0.3.1_chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1_
[wen@pcmaster conduit]$ sed -i -f img.sed  fs.yaml.injected 
[wen@pcmaster conduit]$ grep image: fs.yaml.injected 
      - image: reg.qianbao-inc.com/k8s-monitoring/fs
        image: chinglinwen/gcr.io-runconduit-proxy:v0.3.1
        image: chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1
[wen@pcmaster conduit]$ kubectl apply -f fs.yaml.injected 
error: error converting YAML to JSON: yaml: line 1: mapping values are not allowed in this context
```

```
[wen@pcmaster conduit]$ cat img.sed 
s_gcr.io/runconduit/proxy-init:v0.3.1_chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1_
s_gcr.io/runconduit/controller:v0.3.1_chinglinwen/gcr.io-runconduit-controller:v0.3.1_
s_gcr.io/runconduit/controller:v0.3.1_chinglinwen/gcr.io-runconduit-controller:v0.3.1_
s_gcr.io/runconduit/controller:v0.3.1_chinglinwen/gcr.io-runconduit-controller:v0.3.1_
s_gcr.io/runconduit/controller:v0.3.1_chinglinwen/gcr.io-runconduit-controller:v0.3.1_
s_gcr.io/runconduit/controller:v0.3.1_chinglinwen/gcr.io-runconduit-controller:v0.3.1_
s_gcr.io/runconduit/proxy:v0.3.1_chinglinwen/gcr.io-runconduit-proxy:v0.3.1_
s_gcr.io/runconduit/proxy-init:v0.3.1_chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1_
s_gcr.io/runconduit/web:v0.3.1_chinglinwen/gcr.io-runconduit-web:v0.3.1_
s_gcr.io/runconduit/proxy:v0.3.1_chinglinwen/gcr.io-runconduit-proxy:v0.3.1_
s_gcr.io/runconduit/proxy-init:v0.3.1_chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1_
s_prom/prometheus:v2.1.0_chinglinwen/prom-prometheus:v2.1.0_
s_gcr.io/runconduit/proxy:v0.3.1_chinglinwen/gcr.io-runconduit-proxy:v0.3.1_
s_gcr.io/runconduit/proxy-init:v0.3.1_chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1_
s_grafana/grafana:5.0.0-beta4_chinglinwen/grafana-grafana:5.0.0-beta4_
s_gcr.io/runconduit/proxy:v0.3.1_chinglinwen/gcr.io-runconduit-proxy:v0.3.1_
s_gcr.io/runconduit/proxy-init:v0.3.1_chinglinwen/gcr.io-runconduit-proxy-init:v0.3.1_
[wen@pcmaster conduit]$ 
```

./conduit inject fs.yaml | sed -f img.sed > fs.yaml.injected

need load balancer to access it

conduit 需要ingress 支持 <https://github.com/runconduit/conduit/issues/629>
