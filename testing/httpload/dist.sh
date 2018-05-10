while read l; do
  cnt="$( ss -an|grep 8000 | grep $l | wc -l )"
  echo "$l $cnt"
done<<eof
10.66.192.145:8000
10.66.192.142:8000
10.66.194.5:8000
eof

