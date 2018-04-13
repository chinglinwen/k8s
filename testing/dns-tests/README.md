# dns-tests

```
./start.sh
```

## Issues

still have issues

```
2018-04-12T09:22:56.537422901Z I0412 09:22:56.537309       1 server.go:113] FLAG: --kubecfg-file=""
2018-04-12T09:22:56.53742453Z I0412 09:22:56.537311       1 server.go:113] FLAG: --log-backtrace-at=":0"
2018-04-12T09:22:56.537426265Z I0412 09:22:56.537315       1 server.go:113] FLAG: --log-dir=""
2018-04-12T09:22:56.537427915Z I0412 09:22:56.537318       1 server.go:113] FLAG: --log-flush-frequency="5s"
2018-04-12T09:22:56.537429591Z I0412 09:22:56.537322       1 server.go:113] FLAG: --logtostderr="true"
2018-04-12T09:22:56.537431207Z I0412 09:22:56.537325       1 server.go:113] FLAG: --stderrthreshold="2"
2018-04-12T09:22:56.537432805Z I0412 09:22:56.537327       1 server.go:113] FLAG: --v="2"
2018-04-12T09:22:56.537434427Z I0412 09:22:56.537329       1 server.go:113] FLAG: --version="false"
2018-04-12T09:22:56.537436072Z I0412 09:22:56.537334       1 server.go:113] FLAG: --vmodule=""
2018-04-12T09:22:56.538040929Z I0412 09:22:56.537371       1 server.go:155] Starting SkyDNS server (0.0.0.0:10053)
2018-04-12T09:22:56.538049071Z I0412 09:22:56.537526       1 server.go:165] Skydns metrics enabled (/metrics:10055)
2018-04-12T09:22:56.538051097Z I0412 09:22:56.537533       1 dns.go:144] Starting endpointsController
2018-04-12T09:22:56.538052788Z I0412 09:22:56.537536       1 dns.go:147] Starting serviceController
2018-04-12T09:22:56.53805439Z I0412 09:22:56.537539       1 dns.go:163] Waiting for Kubernetes service
2018-04-12T09:22:56.538056066Z I0412 09:22:56.537542       1 dns.go:169] Waiting for service: default/kubernetes
2018-04-12T09:22:56.538057633Z I0412 09:22:56.537617       1 logs.go:41] skydns: ready for queries on cluster.local. for tcp://0.0.0.0:10053 [rcache 0]
2018-04-12T09:22:56.538065211Z I0412 09:22:56.537625       1 logs.go:41] skydns: ready for queries on cluster.local. for udp://0.0.0.0:10053 [rcache 0]
2018-04-12T09:22:56.639333621Z E0412 09:22:56.639156       1 reflector.go:199] pkg/dns/dns.go:145: Failed to list *api.Endpoints: the server does not allow access to the requested resource (get endpoints)
2018-04-12T09:22:56.63935522Z E0412 09:22:56.639197       1 reflector.go:199] pkg/dns/dns.go:148: Failed to list *api.Service: the server does not allow access to the requested resource (get services)
2018-04-12T09:22:57.64022685Z E0412 09:22:57.640095       1 reflector.go:199] pkg/dns/dns.go:148: Failed to list *api.Service: the server does not allow access to the requested resource (get services)
2018-04-12T09:22:57.64024776Z E0412 09:22:57.640105       1 reflector.go:199] pkg/dns/dns.go:145: Failed to list *api.Endpoints: the server does not allow access to the requested resource (get endpoints)
2018-04-12T09:22:58.641333675Z E0412 09:22:58.641220       1 reflector.go:199] pkg/dns/dns.go:145: Failed to list *api.Endpoints: the server does not allow access to the requested resource (get endpoints)
2018-04-12T09:22:58.641354298Z E0412 09:22:58.641239       1 reflector.go:199] pkg/dns/dns.go:148: Failed to list *api.Service: the server does not allow access to the requested resource (get services)
2018-04-12T09:22:59.642541911Z E0412 09:22:59.642395       1 reflector.go:199] pkg/dns/dns.go:145: Failed to list *api.Endpoints: the server does not allow access to the requested resource (get endpoints)
2018-04-12T09:22:59.642563956Z E0412 09:22:59.642404       1 reflector.go:199] pkg/dns/dns.go:148: Failed to list *api.Service: the server does not allow access to the requested resource (get services)
2018-04-12T09:23:00.64409488Z E0412 09:23:00.643951       1 reflector.go:199] pkg/dns/dns.go:145: Failed to list *api.Endpoints: the server does not allow access to the requested resource (get endpoints)
2018-04-12T09:23:00.644117039Z E0412 09:23:00.643951       1 reflector.go:199] pkg/dns/dns.go:148: Failed to list *api.Service: the server does not allow access to the requested resource (get services)
2018-04-12T09:23:01.645230016Z E0412 09:23:01.645121       1 reflector.go:199] pkg/dns/dns.go:148: Failed to list *api.Service: the server does not allow access to the requested resource (get services)
2018-04-12T09:23:01.645385482Z E0412 09:23:01.645299       1 reflector.go:199] pkg/dns/dns.go:145: Failed to list *api.Endpoints: the server does not allow access to the requested resource (get endpoints)
2018-04-12T09:23:02.646210086Z E0412 09:23:02.646068       1 reflector.go:199] pkg/dns/dns.go:148: Failed to list *api.Service: the server does not allow access to the requested resource (get services)

```
