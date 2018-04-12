# coredns

## 创建coredns

```
./create.sh test-env
```
## 删除kube-dns

确认ok后，删除kube-dns

```
./delete-kubedns.sh
```

生成的yaml文件可保存在此，用目录存放，如:

- [expe-env](dns/coredns/expe-env/expe-env.coredns.yaml)
- test-env
- pro-env