#!/bin/sh

service="$1"
target="$2"
if [ "x$target" = "x" ]; then
  echo "Usage: $0 <service-name> <http url target>"
  exit 1
fi

echo "cmd: $0 $@"
echo "$target" | grep http >/dev/null
if [ $? -ne 0 ]; then
  target="http://$target"
fi
echo "target: $target"

. ./funcs

fs () {
  t fs $1 $2 $target $4
}

name="$( echo $target | awk '{ print $2 }' FS='//' | sed 's/:/\./' )"
#makebase "$service-$name-$( date +%F_%H%M%S )"
makebase "$service-$name"

log=$base/test.log
exec 6>&1
exec > $log
tail -f $log >&2 &

fs 80000 10 
fs 80000 50
fs 80000 100
fs 80000 200
fs 80000 300
fs 80000 500
fs 80000 800
fs 80000 1000
fs 80000 1500
fs 80000 2000
fs 80000 3000
fs 1000000 3000
fs 10000000 3000

echo "End time: $( date +%F_%T )"

pid="$( ps -ef|grep 'tail -f' |grep -v grep | awk '{ print $2 }' )"
kill $pid
exec 1>&6 6>&-

