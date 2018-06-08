kubectl apply -f - <<eof
apiVersion: v1
kind: Pod
metadata:
  name: tiny-tools
  labels:
    env: tiny-tools
spec:
  containers:
  - name: tiny-tools
    image: reg.qianbao-inc.com/k8s/tiny-tools
    command: [ "/bin/sh", "-c", "ls /etc/config/; sleep 36000" ]
    imagePullPolicy: IfNotPresent
eof
