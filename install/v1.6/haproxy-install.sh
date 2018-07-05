#!/bin/sh
# haproxy and keepalived install on masters

curl -so /tmp/k8senv http://fs.qianbao-inc.com/k8s/install/v1.6/env
. /tmp/k8senv

# keepalived and haproxy

yum -y install keepalived haproxy
systemctl enable keepalived
systemctl enable haproxy
echo 'net.ipv4.ip_nonlocal_bind = 1'>>/etc/sysctl.conf
sysctl -p | grep bind

download 


IP="$( ip a | grep 'inet ' | grep -v -e docker -e 127.0.0.1 -e 'vir' | awk '{ print $2 }' | cut -f1 -d'/' )"

cat >/etc/keepalived/keepalived.conf<<eof
global_defs {
   notification_email {
   }
}

vrrp_script check_keepalived {
   script "/etc/haproxy/check_haproxy.sh"
   interval 2
   rise 2
   fall 2
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 198
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111.xxx.2
    }
    unicast_src_ip $IP
    virtual_ipaddress {
        $VIP
    }
    track_script {
        check_keepalived
    }
}
eof

cat > /etc/haproxy/check_haproxy.sh<<"eof"
#!/bin/bash
if [ $(ps -C haproxy --no-header | wc -l) -eq 0 ]; then
     systemctl start haproxy
     exit 1
fi
eof
chmod 755 /etc/haproxy/check_haproxy.sh


# extra cert
cat /etc/kubernetes/ssl/admin.pem /etc/kubernetes/ssl/admin-key.pem >/etc/kubernetes/ssl/k8s-admin.crt

cat >/etc/systemd/system/haproxy.service<<eof
[Unit]
Description=HAProxy Load Balancer
After=syslog.target network.target

[Service]
EnvironmentFile=/etc/sysconfig/haproxy
ExecStart=/usr/sbin/haproxy-systemd-wrapper -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid 
ExecReload=/bin/kill -USR2 
KillMode=mixed
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
eof



cat > /etc/haproxy/haproxy.cfg<<eof
global
    log         127.0.0.1 local2
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     36000
    user        haproxy
    group       haproxy
    daemon
    stats socket /var/lib/haproxy/stats

defaults
    mode                    tcp
    log                     global
    option                  tcplog
    option                  dontlognull
    option                  redispatch
    retries                 3
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    #timeout check           10s
    timeout tunnel          2h
    maxconn                 36000

userlist usersfor_k8s
    user admin insecure-password Admin12345

frontend apiserver_vip_https
    bind $VIP:6443
    default_backend https_server

frontend apiserver_ha_https
    bind 0.0.0.0:443
    default_backend https_server

backend https_server
    option srvtcpka
    balance roundrobin
    server master1 $MASTER1:6443  check inter 10s weight 10
    server master2 $MASTER2:6443  check inter 10s weight 10

listen apiserver_ha_http
    bind 0.0.0.0:80
    mode http
    option httplog 
    option forwardfor
    option redispatch
    option httpchk

    acl AuthOkay_k8s http_auth(usersfor_k8s)
    http-request auth realm KubernetesAdmin if !AuthOkay_k8s

    balance roundrobin
    server master1 $MASTER1:6443  check inter 10s weight 10 ca-file /etc/kubernetes/ssl/ca.pem ssl crt /etc/kubernetes/ssl/k8s-admin.crt
    server master2 $MASTER2:6443  check inter 10s weight 10 ca-file /etc/kubernetes/ssl/ca.pem ssl crt /etc/kubernetes/ssl/k8s-admin.crt

listen  admin_stats
       bind  0.0.0.0:8082
       log  global
       mode  http
       maxconn  10
       stats  enable
       #Hide  HAPRoxy version, a necessity for any public-facing site
       stats  hide-version
       stats  refresh 30s
       stats  show-node
       stats  realm Haproxy\ Statistics
       stats  auth admin:Admin12345
       stats  uri /haproxy?stats
eof


cat >/etc/rsyslog.d/haproxy.conf<<"eof"
/etc/rsyslog.d/haproxy.conf
$ModLoad imudp
$UDPServerRun 514
local2.*                       /var/log/haproxy.log
eof

cat >/etc/sysconfig/rsyslog<<eof
SYSLOGD_OPTIONS="-r -m 0 -c 2"
eof

systemctl start haproxy
systemctl enable haproxy
systemctl start keepalived
systemctl enable keepalived

systemctl status haproxy
systemctl status keepalived
