kubectl delete --namespace=kube-system deployment kube-dns --force --grace-period=0
pods="$( kubectl get pods -n kube-system |grep kube-dns| awk '{ print $1 }' )"
kubectl delete --namespace=kube-system --force --grace-period=0 pods $pods
