kubectl create -f rook-operator.yaml
kubectl create -f rook-cluster.yaml
kubectl create -f rook-tools.yaml
kubectl apply -f rook-storageclass.yaml