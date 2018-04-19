kubectl get ns | grep minions
if [ $? -eq 0 ]; then
  echo "minions namespace exist, may previously running, or not fully deleted, try later"
  exit 1
fi
./run-master.sh
./proxy.sh
./run-minion.sh
echo "See http://$( kubectl get ep -n minions | grep 8888 | awk '{ print $2}' )"/stats
