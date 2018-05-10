Deploy node-exporter outside of cluster


```

extra node-exporter

sftp wenzhenglin@sftp.qianbao-inc.com
get node_exporter

wget https://github.com/prometheus/node_exporter/releases/download/v0.16.0-rc.3/node_exporter-0.16.0-rc.3.linux-amd64.tar.gz

cd
mkdir node-exporter
cd node-exporter
sftp wenzhenglin@sftp.qianbao-inc.com
get node_exporter

cat > start.sh <<'eof'
base=/root/node-exporter
$base/node_exporter &> $base/n.log &
eof
cat > stop.sh <<'eof'
pkill node_exporter
eof
chmod +x start.sh stop.sh
./start.sh


node_uname_info

query label_values(node_boot_time, instance)
label_values(node_uname_info,instance)

grafana variabe changed

graph

Node Exporter Full 1860
label_values(node_boot_time{job=~"$job"}, instance)

changed too, some graph have no data

some metrics not exist, try align with k8s node-exporter

try change from 0.16.0-rc.3 to v0.15.2

./stop.sh
rm -f node_exporter
sftp wenzhenglin@sftp.qianbao-inc.com
get node_exporter

cat > /root/node-exporter/start.sh <<'eof'
base=/root/node-exporter
$base/node_exporter &> $base/n.log &
eof
echo '/root/node-exporter/start.sh' >> /etc/rc.local
tail -2  /etc/rc.local

two dashboard
405 Node Exporter Server Metrics
1860 Node Exporter Full
```
