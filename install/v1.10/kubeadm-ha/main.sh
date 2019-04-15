
sed -i '/node/d' /etc/hosts
hosts="172.28.46.3 node1
172.28.46.4 node2
172.28.46.122 node3"
echo "$hosts" >> /etc/hosts

ssh node1 "bash -s" < ./setup-on-node1.sh
ssh node2 "bash -s" < ./setup-on-othernodes.sh
ssh node3 "bash -s" < ./setup-on-othernodes.sh


while read host; do
  ssh $host "bash -s" < ./setup-on-all.sh
done<<eof
node1
node2
node3
eof

while read host; do
  ssh $host "bash -s" < ./install-etcd.sh
done<<eof
node1
node2
node3
eof
