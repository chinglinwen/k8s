./netperf -kubeConfig ~/.kube/config &> netperf.log &
tail -f netperf.log
