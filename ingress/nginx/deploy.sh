kubectl apply -f namespace.yaml
kubectl apply -f default-backend.yaml
kubectl apply -f configmap.yaml
kubectl apply -f tcp-services-configmap.yaml
kubectl apply -f udp-services-configmap.yaml
kubectl apply -f rbac.yaml
kubectl apply -f with-rbac.yaml

