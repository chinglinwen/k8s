kubectl apply -f - <<eof
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  labels:
    env: test
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: [ "/bin/sh", "-c", "ls /etc/config/; sleep 36000" ]
    imagePullPolicy: IfNotPresent
eof
