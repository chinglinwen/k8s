kubectl delete ns minions
pkill proxy.sh
kill $( ps -ef|grep port-forward | grep -v grep | awk '{ print $2 }' )
