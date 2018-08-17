ns=${NS:=qb-pro}
export $NS
kubectl create ns $ns
kubectl delete -n $ns -f fs.yaml
kubectl apply -n $ns -f fs.yaml 
kubectl apply -n $ns -f fs.ingress

# we use post start instead, no need this
#sleep 5
#./fs-contents.sh
