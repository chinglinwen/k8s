while read l; do
  cnt="$( ss -an|grep 8000 | grep $l | wc -l )"
  echo "$l $cnt"
done<<eof
10.66.193.19:8000
10.66.196.83:8000
10.66.194.5:8000
eof

