# pod-tests
## 测试内容

1. 单节点最大pod数

## issues

```
$ ./pod_stats.py data.csv 
Traceback (most recent call last):
  File "./pod_stats.py", line 85, in <module>
    main()
  File "./pod_stats.py", line 42, in main
    t.append(k - base_time)
TypeError: unsupported operand type(s) for -: 'numpy.string_' and 'numpy.string_'
```
## 参考

1. https://docs.openstack.org/developer/performance-docs/test_plans/kubernetes_density/plan.html
