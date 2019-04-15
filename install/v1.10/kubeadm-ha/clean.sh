
clear (){
   host=$1
   ssh -n $host "systemctl stop etcd"
   echo "$host stop etcd."

   ssh -n $host "rm -rf /etc/etcd"
   echo "$host delete etcd config."

   ssh -n $host "rm -rf  /var/lib/etcd"
   echo "$host delete etcd data."
}

hosts="node1
node2
node3"
echo "$hosts" | while read host; do
  echo "item: $host"
  clear $host
done

echo "end."
