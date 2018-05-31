loadstatus(){
echo "for master$( uptime )"
while read l; do
  echo "for $l $( ssh -n $l  uptime )"
done<<eof
node1
node2
node3
eof
}
loadstatus
