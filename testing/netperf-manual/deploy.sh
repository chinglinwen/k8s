
kubectl create -f - <<eof
kind: Service
apiVersion: v1
metadata:
  name: iperf3-service
spec:
  selector:
    app: iperf3
  ports:
  - protocol: TCP
    port: 5201
    targetPort: 5201
  type: NodePort
eof

kubectl create -f - <<eof
apiVersion: apps/v1beta1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: iperf3
  labels:
    app: iperf
spec:
  replicas: 4
  selector:
    matchLabels:
      app: iperf3
  template:
    metadata:
      labels:
        app: iperf3
    spec:
      containers:
        - name: iperf3
          image: reg.qianbao-inc.com/k8s/networkstatic-iperf3
          command: [ "/bin/sh", "-c", "echo starting... ; sleep 36000" ]
eof
