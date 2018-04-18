ip="$( ip a | grep 'inet ' | grep -v -e '127.0.0.' -e 'docker0' | awk '{ print $2 }' | awk '{ print $1 }' FS='/' )"
echo "http://$ip:8003"
