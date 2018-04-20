kubectl top nodes 2>/dev/null

echo "total number of pods: $( kubectl get pods --all-namespaces -o wide|grep -v NAME|wc -l )"
while read l; do
  n="$( kubectl get pods --all-namespaces -o wide|grep -v NAME|grep $l |wc -l )"
  echo "number of pod for node $l : $n"
done <<eof
$( kubectl get nodes | grep -v NAME | awk '{ print $1 }'  )
eof

echo "number of ip used: $( kubectl get pods,ep -o wide --all-namespaces|grep -v -e none -e NAMESPACE -e '^$' | wc -l )"
echo

#echo "detail:"
#kubectl get pods --all-namespaces -o wide|grep -v NAME
