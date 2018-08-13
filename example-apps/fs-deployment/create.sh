ns=${NS:=qb-pro}
export $NS
kubectl create ns $ns
kubectl delete -n $ns -f fs.yaml
kubectl apply -n $ns -f fs.yaml 
kubectl apply -n $ns -f fs.ingress
sleep 5
./fs-contents.sh
