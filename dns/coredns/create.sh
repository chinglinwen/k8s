#!/bin/sh

base=$1
if [ "x$base" = "x" ]; then
  echo "cluster-env not provided, one of [expe-env,test-env,pro-env]"
  echo "Usage: $0 env-name"
  exit 1
fi
mkdir $base
file="$base/$base.coredns.yaml"
./deploy.sh > "$file"
kubectl apply -f "$file"
echo "Done, coredns is now working in place."

echo "See if coredns is ok, then manual delete kubedns by execute ./delete-kubedns.sh"
