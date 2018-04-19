kubectl get ns | grep minions
if [ $? -eq 0 ]; then
  echo "minions namespace exist, may previously running, or not fully deleted, try later"
  exit 1
fi
../pretest.sh
./run-master.sh
./proxy.sh
echo "Start time: $(date "+%s%N")"
./run-minion-deploy-manner.sh
echo "See http://$( kubectl get ep -n minions | grep 8888 | awk '{ print $2}' )"/stats
