if kubectl get pod -n minions 2 >/dev/null | grep master ; then
  echo "master already running"
  echo "try cleanup"
  ./cleanup.sh
  exit
fi
./run-master.sh
./proxy.sh
