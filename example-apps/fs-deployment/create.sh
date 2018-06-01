kubectl create ns qb-pro
kubectl delete -f fs.yaml
kubectl apply -f fs.yaml 
kubectl apply -f fs.ingress
sleep 5
./fs-contents.sh
