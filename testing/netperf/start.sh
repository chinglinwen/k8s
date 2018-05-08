echo "Start time: $(date "+%s%N")" >> netperf.log
netperf -kubeConfig ~/.kube/config &>> netperf.log &
tail -f netperf.log
echo "End time(manual): $(date "+%s%N")" >> netperf.log
