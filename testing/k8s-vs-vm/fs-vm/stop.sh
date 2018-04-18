pid="$( netstat -ntpl|grep 8003 | awk '{ print $NF }' | cut -f1 -d'/' )"
kill $pid
