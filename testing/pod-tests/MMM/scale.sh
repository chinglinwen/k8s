n=${1:-50}
kubectl -n minions get rc minion
echo "scaling to $n ..."
kubectl -n minions scale rc minion --replicas=$n
echo "After scaled:"
kubectl -n minions get rc minion
