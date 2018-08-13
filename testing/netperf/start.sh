#!/bin/sh

if ! `which netperf >/dev/null 2>&1` ; then
  wget fs.qianbao-inc.com/soft/netperf -O /usr/local/bin/netperf
  chmod +x /usr/local/bin/netperf
fi

./loadstatus.sh  >> netperf.log
echo "Start time: $( date +%F_%T )" >> netperf.log
netperf -kubeConfig ~/.kube/config &>> netperf.log &
tail -f netperf.log
echo "End time(manual): $( date +%F_%T )" >> netperf.log
