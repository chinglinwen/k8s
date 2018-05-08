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

fs 20000 10 
fs 20000 50
fs 20000 100
fs 20000 200
fs 20000 300
fs 20000 500

echo "End time: $( date +%F_%T )"

pid="$( ps -ef|grep 'tail -f' |grep -v grep | awk '{ print $2 }' )"
kill $pid
exec 1>&6 6>&-

