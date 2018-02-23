# k8s-testing

## k8s-conformance

步骤：https://github.com/cncf/k8s-conformance/blob/master/instructions.md

实验环境测试结果：

```
Summarizing 7 Failures:

[Fail] [sig-api-machinery] Downward API [It] should provide host IP as an env var  [Conformance] 
/go/src/k8s.io/kubernetes/_output/dockerized/go/src/k8s.io/kubernetes/test/e2e/framework/util.go:446

[Fail] [sig-network] DNS [It] should provide DNS for the cluster  [Conformance] 
/go/src/k8s.io/kubernetes/_output/dockerized/go/src/k8s.io/kubernetes/test/e2e/network/dns.go:170

[Fail] [sig-scheduling] SchedulerPredicates [Serial] [BeforeEach] validates that NodeSelector is respected if not matching  [Conformance] 
/go/src/k8s.io/kubernetes/_output/dockerized/go/src/k8s.io/kubernetes/test/e2e/scheduling/predicates.go:88

[Fail] [sig-api-machinery] Downward API [It] should provide pod UID as env vars  [Conformance] 
/go/src/k8s.io/kubernetes/_output/dockerized/go/src/k8s.io/kubernetes/test/e2e/framework/util.go:446

[Fail] [sig-scheduling] SchedulerPredicates [Serial] [BeforeEach] validates that NodeSelector is respected if matching  [Conformance] 
/go/src/k8s.io/kubernetes/_output/dockerized/go/src/k8s.io/kubernetes/test/e2e/scheduling/predicates.go:88

[Fail] [sig-api-machinery] CustomResourceDefinition resources Simple CustomResourceDefinition [It] creating/deleting custom resource definition objects works  [Conformance] 
/go/src/k8s.io/kubernetes/_output/dockerized/go/src/k8s.io/kubernetes/test/e2e/framework/util.go:446

[Fail] [sig-scheduling] SchedulerPredicates [Serial] [BeforeEach] validates resource limits of pods that are allowed to run  [Conformance] 
/go/src/k8s.io/kubernetes/_output/dockerized/go/src/k8s.io/kubernetes/test/e2e/scheduling/predicates.go:88

Ran 125 of 710 Specs in 3639.387 seconds
FAIL! -- 118 Passed | 7 Failed | 0 Pending | 585 Skipped --- FAIL: TestE2E (3639.43s)
FAIL
```

## kube-monkey

try https://github.com/asobti/kube-monkey later?