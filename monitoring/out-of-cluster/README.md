# Prometheus for k8s outside cluster version

## Get token

```
./gettoken.sh
```

copy the token to replace prometheus.yml file all token string

See: [example-targets.pdf](example-targets.pdf)

## Grafana hook service

see <http://issue.qianbao-inc.com/wenzhenglin/grafana-alert>

url: http://localhost:8002
> run in the same server, so use localhost is ok.