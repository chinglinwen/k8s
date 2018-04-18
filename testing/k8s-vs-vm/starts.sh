while read i; do
  cd $i
  ./start.sh
  cd ..
done <<eof
$( ls | grep fs- )
eof
