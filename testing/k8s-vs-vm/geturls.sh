while read i; do
  cd $i
  url="$( ./geturl.sh 2>/dev/null )"
  if [ "x$url" = "x" ]; then
    echo $i not running
    cd ..
    continue
  fi

  curl -s $url >/dev/null
  if [ $? -ne 0 ]; then
    echo $i not running
    cd ..
    continue
  fi

  echo "$i $url"
  cd ..
done <<eof
$( ls | grep fs- )
eof
