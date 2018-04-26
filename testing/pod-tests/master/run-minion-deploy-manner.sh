#!/bin/bash

envs="$( env | grep -w -e N -e ALLNODES -e REPLICA -e MEM -e RESOURCE )"
echo "Env setting: $( echo $envs )"
echo

n=${N:=1}
ALLNODES=${ALLNODES:-false}

if [ "x$ALLNODES" = "xfalse" ]; then
  nodeip="$( kubectl get nodes -o yaml | grep kubernetes.io/hostname| head -1 | awk '{ print $2 }' FS=':' )"
  echo "will run on single node only, select node is: $nodeip"
  NODE="  $( kubectl get nodes -o yaml | grep kubernetes.io/hostname| head -1 )"
  NODESELECT="      nodeSelector:
$NODE
"
fi
REPLICA=${REPLICA:=3}
MEM=${MEM:=1G}
resource="          resources:
            limits:
              #cpu: 2
              memory: $MEM
            requests:
              #cpu: 500m
              memory: $MEM"
RESOURCE=${RESOURCE:=$resource}

echo "Replica is: $REPLICA"
echo "Resource: 
$RESOURCE"
echo "N: $n"

echo "Will create $n number of deployments"
#echo "Start time: $(date "+%s%N")"


initcnt="$( kubectl get event -n minions |grep Warn | grep -v -e 'pull image' -e ErrImagePull -e ImagePullBackOff | wc -l )"
((initcnt++))

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

  warns="$( kubectl get event -n minions |grep Warn | grep -v -e 'pull image' -e ErrImagePull -e ImagePullBackOff | tail -n +$initcnt | grep Warn )"
  if [ $? -eq 0 ]; then
    warncnt="$( echo "$warns" | awk '{ print $2 }' FS='::' | wc -l )"
    warntext="$( echo "$warns" | awk '{ print $2 }' FS='::' | head -3 )"
    echo "Out of resource: $warncnt"
    #echo "$warntext"
    echo "$warns"
    echo "stop create deploy at $i"
    break
  fi
}

#echo "End time: $(date "+%s%N")"
