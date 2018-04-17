./run-master.sh
sleep 3
./proxy.sh &
./run-minion.sh
echo "See http://$( kubectl get ep -n minions | grep 8888 | awk '{ print $2}' )"/stats
