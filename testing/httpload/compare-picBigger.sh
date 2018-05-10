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
  t $1 $2 $3 $4 $5
}

name="$( echo $target | awk '{ print $2 }' FS='//' | sed 's/:/\./' )"
#makebase "$service-$name-$( date +%F_%H%M%S )"
makebase "$service-$name"

log=$base/test.log
exec 6>&1
exec > $log
tail -f $log >&2 &

#t fspod 1000000 3000 http://10.66.194.5:8000
#t fsnginx 1000000 3000 http://protest.wk.qianbao-inc.com
#t fsgob 1000000 3000 http://protest.wk.qianbao-inc.com:3000

t fspod 500 100 http://10.66.194.5:8000/desert.jpg
t fsgob 500 100 http://protest.wk.qianbao-inc.com:3000/desert.jpg
t fsnginx 500 100 http://protest.wk.qianbao-inc.com/desert.jpg

t fspod 1000 200 http://10.66.194.5:8000/desert.jpg
t fsgob 1000 200 http://protest.wk.qianbao-inc.com:3000/desert.jpg
t fsnginx 1000 200 http://protest.wk.qianbao-inc.com/desert.jpg

t fspod 2000 300 http://10.66.194.5:8000/desert.jpg
t fsgob 2000 300 http://protest.wk.qianbao-inc.com:3000/desert.jpg
t fsnginx 2000 300 http://protest.wk.qianbao-inc.com/desert.jpg

t fspod 4000 300 http://10.66.194.5:8000/desert.jpg
t fsgob 4000 300 http://protest.wk.qianbao-inc.com:3000/desert.jpg
t fsnginx 4000 300 http://protest.wk.qianbao-inc.com/desert.jpg

t fspod 8000 1000 http://10.66.194.5:8000/desert.jpg
t fsgob 8000 1000 http://protest.wk.qianbao-inc.com:3000/desert.jpg
t fsnginx 8000 1000 http://protest.wk.qianbao-inc.com/desert.jpg

echo "End time: $( date +%F_%T )"

pid="$( ps -ef|grep 'tail -f' |grep -v grep | awk '{ print $2 }' )"
kill $pid
exec 1>&6 6>&-

