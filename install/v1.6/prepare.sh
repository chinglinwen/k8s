
ENV="${ENV:=pre-env}"
ln -sf $ENV env
. $ENV

SUFFIX1="$( echo $ETCD1 | awk '{ print $NF }' FS='.' )"
SUFFIX2="$( echo $ETCD2 | awk '{ print $NF }' FS='.' )"
SUFFIX3="$( echo $ETCD3 | awk '{ print $NF }' FS='.' )"

# ignore vip here, but hosts may needed
hosts="$MASTER1 master1 #k8s
$MASTER2 master2 #k8s
$ETCD1 etcd1 etcd-$SUFFIX1 #k8s
$ETCD2 etcd2 etcd-$SUFFIX2 #k8s
$ETCD3 etcd3 etcd-$SUFFIX3 #k8s
$NODE1 node1 #k8s
$NODE2 node2 #k8s
$NODE3 node3 #k8s"

cat>hosts.sh<<eof
sed -i '/#k8s/d' /etc/hosts
cat >>/etc/hosts<<eof1
$hosts
eof1
eof

HOSTS="\"$VIP\",
\"$MASTER1\",
\"$MASTER2\",
\"$ETCD1\",
\"$ETCD2\",
\"$ETCD3\",
\"$NODE1\",
\"$NODE2\",
\"$NODE3\","

curl http://fs.qianbao-inc.com/k8s/install/v1.6/uploadapi -F file=@env
curl http://fs.qianbao-inc.com/k8s/install/v1.6/uploadapi -F file=@$ENV
