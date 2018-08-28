#!/bin/sh

base=/metrics
mkdir -p $base
cd $base
mfile=$base/metrics

ip="$( ip a | grep global | awk '{ print $2 }' | cut -f1 -d'/' | head -1 )"

which calc >/dev/null
if [ $? -ne 0 ]; then
  wget http://fs.qianbao-inc.com/soft/calc -O /usr/local/bin/calc
  chmod +x /usr/local/bin/calc
fi
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
    echo "podping {host=\"$ip\",target=\"$desc\"} -1"
    return
  fi
  v="$( ping -w 1 -c 1 $ip  | grep avg  | awk '{ print $5 }' FS='/' )"
  n="$( calc "$v * 1000" )"
  if [ $? -eq 0 ]; then
    echo "podping {host=\"$ip\",target=\"$desc\"} $n"
    return
  fi
  echo "podping {host=\"$ip\",target=\"$desc\"} -2"
}

nets () {
  net "gateway" 10.64.192.1
  net "master" 10.64.167.200
  #net "master11" 10.64.167.11
  #net "master12" 10.64.167.12
}

while true; do
  x="$( nets )"
  echo -e "$(date +%F_%T )\n$x"
  echo
  echo "$x" > $mfile
  sleep 1
done
