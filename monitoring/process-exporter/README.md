# Process-exporter

1. https://github.com/ncabatoff/process-exporter
1. https://grafana.com/dashboards/249

## Install

curl http://fs.qianbao-inc.com/k8s/monitor/process-exporter/install.sh | sh

## Prometheus config

```
  - job_name: 'process-exporter'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['10.66.0.10:9256']
      - targets: ['10.66.0.11:9256']
      - targets: ['10.66.0.12:9256']
      - targets: ['10.66.0.18:9256']
```

## Links

<http://grafana.wk.qianbao-inc.com/d/7e0IqIKiz/named-processes?refresh=10s&orgId=1&from=now-30m&to=now>