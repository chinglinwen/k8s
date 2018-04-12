#kubectl apply -f traefik-rbac.yaml -f traefik-ds.yaml -f ui.yaml
kubectl apply -f traefik-rbac.yaml -f traefik-deployment.yaml -f ui.yaml
#kubectl apply -f prometheus-ingress.yaml
