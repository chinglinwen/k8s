export CLUSTERCIDR="10.32.0.0/12"
export APISERVER="http://172.28.40.251:8080"
cat generic-kuberouter-all-features.yaml | \
sed -e "s;%APISERVER%;$APISERVER;g" -e "s;%CLUSTERCIDR%;$CLUSTERCIDR;g" | \
sed -e "s;run-firewall=true;run-firewall=false;g" | \
sed -e 's;cloudnativelabs/kube-router;reg.qianbao-inc.com/base/kube-router;g' > generic-kuberouter-all-features.new.yaml
