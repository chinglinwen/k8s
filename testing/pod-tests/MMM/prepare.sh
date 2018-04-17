#!/bin/bash
REGISTRY="reg.qianbao-inc.com/k8s"
MY_PATH="`dirname \"$0\"`" 
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"

#for i in master minion mariadb; do
for i in master ; do
  docker build -t $REGISTRY/$i $MY_PATH/$i/
  docker push $REGISTRY/$i
done

