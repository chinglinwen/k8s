#!/bin/sh

echo "Start time: $(date "+%s%N")"

if [ "x$FORMAL" = "x" ]; then
  n1=${N1:=3}
  n2=${N2:=3}
  n3=${N3:=3}
  n4=${N4:=3}
  n5=${N5:=3}
  n6=${N6:=3}
else
  n1=${N1:=100}
  n2=${N2:=100}
  n3=${N3:=100}
  n4=${N4:=300}
  n5=${N5:=100}
  n6=${N6:=100}
fi

echo "n1: $n1"
echo "n2: $n2"
echo "n3: $n3"
echo "n4: $n4"

if [ ! -d master ]; then
  echo "master directory not found"
  exit 1
fi

base="$PWD"
masterdir="$base/master"

#resultdir="$base/data-$( date +%Y%m%d-%H%M%S )"
#mkdir $resultdir

resultdir="$base"

cd $masterdir

$base/pretest.sh

# default not start master
# set a variable to restart master
master() {
  $base/delete.sh 
  ./start.sh
}
if [ "x$RESTART" != "x" ]; then
  master
fi

echo "See http://$( kubectl get ep -n minions | grep 8888 | awk '{ print $2}' )"/stats

out(){
  item="$1"
  $base/kubectl_mon.py &> $resultdir/$item.out &
}

# create max deploy with limit setting
test1 () {
  out test1
  N=$n1 ./run-minion-deploy-manner.sh
}

# create max deploy
test2 () {
  out test2
  N=$n2 RESOURCE="#" ./run-minion-deploy-manner.sh
}

# create max deploy, all nodes, with limit
test3 () {
  out test3
  N=$n3 ALLNODES=true ./run-minion-deploy-manner.sh
}

# create max deploy, all nodes
test4 () {
  out test4
  RESOURCE="#" N=$n4 ALLNODES=true ./run-minion-deploy-manner.sh
}

test5 () {
  out test5
  N=$n5 ./run-minion.sh && ./pod-destroy.sh
}

test6 () {
  out test6
  RESOURCE="#" N=$n6 ./run-minion-deploy-manner.sh && ./deploy-destroy.sh
}

testall(){
  test1
  test2
  test3
  test4
  test5
  test6
}

case $1 in
  1) test1 ;;
  2) test2 ;;
  3) test3 ;;
  4) test4 ;;  
  5) test5 ;;
  6) test6 ;;
  *) testall ;;
esac

echo "End time: $(date "+%s%N")"

# end.
