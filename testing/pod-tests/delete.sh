kubectl delete ns minions --force --grace-period=0 2>/dev/null
pkill proxy.sh
kill $( ps -ef|grep port-forward | grep -v grep | awk '{ print $2 }' ) 2>/dev/null
while kubectl get pod,ns -n minions 2>/dev/null | grep minion >/dev/null ; do
  echo "waiting deleting"
  sleep 3
done
echo "fully deleted"
