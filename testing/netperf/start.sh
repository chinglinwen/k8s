echo "Start time: $( date +%F_%T )" >> netperf.log
netperf -kubeConfig ~/.kube/config &>> netperf.log &
tail -f netperf.log
echo "End time(manual): $( date +%F_%T )" >> netperf.log
