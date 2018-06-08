cd /etc/etcd

export PRIVATE_IP="$( ip addr show `ip r |grep default | awk '{ print $NF }'` | grep -Po 'inet \K[\d.]+' )"
export PEER_NAME="$( grep $PRIVATE_IP /etc/hosts | awk '{ print $2 }' )"


cfssl print-defaults csr > config.json
sed -i '0,/CN/{s/example\.net/'"$PEER_NAME"'/}' config.json
sed -i 's/www\.example\.net/'"$PRIVATE_IP"'/' config.json
sed -i 's/example\.net/'"$PEER_NAME"'/' config.json


cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server config.json | cfssljson -bare server

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer config.json | cfssljson -bare peer
