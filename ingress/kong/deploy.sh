kubectl get ns | grep rook &> /dev/null
if [ $? -ne 0 ]; then
  echo "warning, storage not setup yet, go to storage/rook/deploy.sh"
fi
kubectl create -f all-in-one-postgres.yaml.new
