#!/bin/sh

base=~/metrics
cd $base
mfile=$base/metrics

netstat -ntpl | grep fs | grep 8000
if [ $? -ne 0 ]; then
  which fs >/dev/null
  if [ $? -ne 0 ]; then
    curl http://fs.qianbao-inc.com/soft/fs/install.sh | sh
  fi
  fs &
fi

net (){
  desc="$1"
  ip="$2"
  out="$( ping -w 1 -c 1 $ip )"
  if [ "x$out" = "x" ]; then
    echo "ping {target=\"$desc\"} -1"
    return
  fi
  v="$( ping -w 1 -c 1 $ip  | grep avg  | awk '{ print $5 }' FS='/' )"
  n="$( echo "$v * 1000" | bc )"
  if [ $? -eq 0 ]; then
    echo "ping {target=\"$desc\"} $n"
    return
  fi
  echo "ping {target=\"$desc\"} -2"
}

nets () {
  net "gateway" 10.64.48.1
  net "node11" 10.64.60.11
  net "node12" 10.64.60.12
  net "node13" 10.64.60.13
  net "master11" 10.64.167.11
  net "master12" 10.64.167.12
}

while true; do
  x="$( nets )"
  echo -e "$(date +%F_%T )\n$x"
  echo
  echo "$x" > $mfile
  sleep 1
done

