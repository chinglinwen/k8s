# Crash Testing

模拟极端场景测试集群的健壮性

## 测试方法

通过对所有组件模拟crash测试，目前主要是对系统crash的模拟：

```bash
echo c > /proc/sysrq-trigger 
```

## master组件

etcd 所有节点
master所有节点

## 节点组件

所有k8s节点

## 结果验证
crash后应对业务应用不影响，且集群能正常恢复。