#!/bin/bash

n=${N:=1}
ALLNODES=${ALLNODES:-false}

if [ "x$ALLNODES" = "xfalse" ]; then
  NODE="  $( kubectl get nodes -o yaml | grep kubernetes.io/hostname| tail -1 )"
  NODESELECT="      nodeSelector:
$NODE
"
fi
REPLICA=${REPLICA:=1}
MEM=${MEM:=1G}
resource="          resources:
            limits:
              #cpu: 2
              memory: $MEM
            requests:
              #cpu: 500m
              memory: $MEM"
RESOURCE=${RESOURCE:=$resource}

echo "Will create $n number of deployments"
#echo "Start time: $(date "+%s%N")"

for ((i=1;i <= $n;i++)) {
  NUMBER=$i
  cat <<eof | kubectl create -f -
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: minion-$NUMBER
  namespace: minions
  labels:
    app: minion-$NUMBER
spec:
  replicas: $REPLICA
  selector:
    matchLabels:
      app: minion-$NUMBER
  template:
    metadata:
      labels:
        app: minion-$NUMBER
    spec:
      containers:
        - name: minion-$NUMBER
          image: reg.qianbao-inc.com/k8s/mmm-minion:latest
$RESOURCE
          env:
          - name: MINION_RC
            value: "$NUMBER"
$NODESELECT
eof
}

#echo "End time: $(date "+%s%N")"
