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
  n1=${N1:=1000}
  n2=${N2:=1000}
  n3=${N3:=1000}
  n4=${N4:=3000}
  n5=${N5:=1000}
  n6=${N6:=1000}
fi

echo "n1: $n1"
echo "n2: $n2"
echo "n3: $n3"
echo "n4: $n4"
echo "n5: $n5"
echo "n6: $n6"

if [ ! -d master ]; then
  echo "master directory not found"
  exit 1
fi

base="$PWD"
masterdir="$base/master"


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
  echo
  echo "====== TEST: $item ======"
  $base/kubectl_mon.py &> $resultdir/$item.out &
}

initcnt="$( kubectl get event -n minions |grep Warn | grep -v -e 'pull image' -e ErrImagePull -e ImagePullBackOff | wc -l )"
((initcnt++))
cleanup () {
  while true; do
    warns="$( kubectl get event -n minions |grep Warn | grep -v -e 'pull image' -e ErrImagePull -e ImagePullBackOff | tail -n +$initcnt | grep Warn )"
    if [ $? -eq 0 ]; then
      warncnt="$( echo "$warns" | awk '{ print $2 }' FS='::' | wc -l )"
      #warntext="$( echo "$warns" | awk '{ print $2 }' FS='::' | head -3 )"
      echo "Out of resource: $warncnt"
      echo "$warns"
      break
    fi
    podn="$( kubectl get pod -n minions | grep minion | wc -l | awk '{ print $1 }' )"
    podr="$( kubectl get pod -n minions | grep minion | grep Run | wc -l | awk '{ print $1 }' )"
    if [ $podr -ne $podn ]; then
      echo "waiting up runining to $podn"
      sleep 1
      continue
    fi
    break
  done
  
  echo "Try end tests. do cleaning...."
  $masterdir/cleanup.sh
  
  # stop output
  ps -ef|grep kubectl_mon.py | grep -v grep | awk '{ print $2 }' | xargs kill
  
  cnt="$( ps -ef | grep $$ | grep -v -w -e grep -e 'ps -ef' -e tail -e wc -e awk | wc -l | awk '{ print $1 }' )"
  if [ $cnt -ne 1 ]; then
    echo "Something not cleaned up, see following ps output"
    ps -ef | grep $$
  fi
  N=  # reset N
}

# create max deploy with limit setting
test1 () {
  out test1
  N=$n1 ./run-minion-deploy-manner.sh
  cleanup
}

# create max deploy
test2 () {
  out test2
  N=$n2 RESOURCE="#" ./run-minion-deploy-manner.sh
  cleanup
}

# create max deploy, all nodes, with limit
test3 () {
  out test3
  N=$n3 ALLNODES=true ./run-minion-deploy-manner.sh
  cleanup
}

# create max deploy, all nodes
test4 () {
  out test4
  RESOURCE="#" N=$n4 ALLNODES=true ./run-minion-deploy-manner.sh
  cleanup
}

test5 () {
  out test5
  ./run-minion.sh && T=$n5 ./pod-destroy.sh
  cleanup
}

test6 () {
  out test6
  RESOURCE="#" ./run-minion-deploy-manner.sh && T=$n6 ./deploy-destroy.sh
  cleanup
}

test7 () {
  out test7
  i=1
  while true; do
    if [ $i -gt 100 ]; then
      break
    fi
    echo "Starting $i round...."
    RESOURCE="#" N=$n4 ALLNODES=true ./run-minion-deploy-manner.sh
    cleanup
    ((i++))
  done
  echo "Runned $i rounds:"
}

testall(){
  echo
  echo "Doing all tests."

  resultdir="$base/data-$( date +%Y%m%d-%H%M%S )"
  mkdir $resultdir

  log=$resultdir/test.log
  exec 6>&1
  exec > $log
  tail -f $log >&2 &

  test1
  test2
  test3
  test4
  test5
  test6

  pid="$( ps -ef|grep 'tail -f' |grep -v grep | awk '{ print $2 }' )"
  kill $pid
  exec 1>&6 6>&-
}

case $1 in
  1) test1 ;;
  2) test2 ;;
  3) test3 ;;
  4) test4 ;;  
  5) test5 ;;
  6) test6 ;;
  7) test7 ;;
  *) testall ;;
esac

echo "End time: $(date "+%s%N")"

# end.
