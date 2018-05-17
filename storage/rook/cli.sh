echo "Ceph df---"
kubectl exec -it rook-tools -n rook ceph df

echo
echo "Rados df---"
kubectl exec -it rook-tools -n rook rados df
