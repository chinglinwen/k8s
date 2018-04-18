while read i; do
  cd $i
  ./stop.sh
  cd ..
done <<eof
$( ls | grep fs- )
eof

