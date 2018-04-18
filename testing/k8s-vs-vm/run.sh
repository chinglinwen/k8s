#!/bin/sh
# run the test one by one

. ./funcs

set -x

fs () {
  t $i $1 $2 $url
}

geturl () {
  while true; do
    urla="$( ./geturl.sh 2>/dev/null )"
    if [ "x$urla" != "x" ]; then
      break
    fi
    echo "waiting url..."
  done
  echo $urla
}

./stops.sh
while read i; do
  cd $i
  ./start.sh
  url="$( geturl )"
  echo "url: $url"

  makebase "../data-$i-$( date +%F_%H%M%S )"
  
  fs 1s 100
  #fs 10s 100
  #fs 10s 1000
  #fs 10s 10000

  ./stop.sh
  cd ..
done <<eof
fs-vm
eof

#$( ls | grep fs- )
#eof

