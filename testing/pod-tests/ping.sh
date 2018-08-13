ns=${NS:=default}
all=""
i=0

list="$( kubectl get pods -n $ns -o wide | grep Run | awk '{ print $6}' | grep -v -e IP -e none )"
if [ "x$list" = "x" ]; then
  echo "no ip found"
  exit 1
fi
while read l; do
  ((i++))
  out="$( ping -W 1 -c 1 $l )"
  if [ $? -eq 0 ]; then
    if [ $( echo $i % 7 | bc ) -eq 0 ]; then
      all="$all\t$l \tok\n"
    else
      all="$all\t$l \tok"
    fi
  else
    echo "$l fail"
    echo -e "ip: $l =========$( date +%F_%T )=========\n$out\n" >> ping_fail.txt
    echo "$out"
  fi
done<<eof
$list
eof
headline="$i of pods\n"
echo -e "$headline$all"
