# example-apps

样例应用，用于k8s平台测试

每个样例在此repo创建一个文件夹（命名：app-name-k8s-type，如：nginx-deployment）

## 样例规范

样例应用需要至少包含以下内容：

1. 容器ready（容器源文件和对应build好的image路径）
2. k8s yaml文件ready

## 常见应用种类

> 优先无状态类？

1. ? nginx, tomcat, dubble?
2. ?

高级应用

1. 多容器
1. 多实例水平自动扩展
2. benchmark examples?

## 常见k8s类型

1. Deployment
2. StatefulSets
3. DaemonSet
4. Job
5. CronJob

## 监控设置ok

1. Healthy check, readiness probe, etc
1. Others? ( our monitoring system? see <http://issue.qianbao-inc.com/SRE/monitoring> )

## 其它事项

对应的集群版本可能会有变化，为保证可重复性，对应的yaml文件可能有变化 ( 自动转换见：<https://github.com/fleeto/kube-version-converter> )

测试应可轻易重复性（如一条命令）