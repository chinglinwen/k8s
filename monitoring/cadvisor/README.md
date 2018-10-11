# For version above 1.7

## manual deploy cadvisor

```
docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=4194:8080 \
  --detach=true \
  --name=cadvisor \
  harbor.wk.qianbao-inc.com/k8s/cadvisor
```

visit: http://nodeip:4194/