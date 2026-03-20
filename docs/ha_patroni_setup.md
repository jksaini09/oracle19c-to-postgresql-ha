# High Availability PostgreSQL Cluster using Patroni, Etcd, and HAProxy

## Overview

This section describes the setup of a Highly Available PostgreSQL 14 cluster using:

* Patroni (cluster manager)
* Etcd (distributed configuration store)
* HAProxy (load balancer)

---

## 1. Prepare All Nodes

### Set Hostnames

```id="6y1n8b"
hostnamectl set-hostname node1
```

Repeat for node2, node3, haproxy-node.

---

### Configure /etc/hosts

```id="0plk0j"
vim /etc/hosts
```

Add:

```id="r7z3kq"
172.14.14.120 node1
172.14.14.127 node2
172.14.14.128 node3
172.14.14.129 haproxy-node
```

---

## 2. Disable Firewall and SELinux

```id="m9npn3"
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
```

---

## 3. Install Required Packages

```id="9gk6xj"
dnf update -y
dnf install -y epel-release
dnf install -y python3-pip python3-devel gcc
```

---

## 4. Install PostgreSQL and Patroni

```id="y8xjtz"
dnf install -y percona-postgresql14-server
dnf install -y percona-patroni etcd python3-python-etcd percona-pgbackrest
```

Stop services:

```id="m4s4d9"
systemctl stop postgresql-14 patroni etcd
systemctl disable postgresql-14 patroni etcd
```

---

## 5. Configure Etcd Cluster

Edit:

```id="o3utem"
/etc/etcd/etcd.conf.yaml
```

Example for node1:

```id="ytzrb6"
name: 'node1'
initial-cluster: node1=http://172.14.14.120:2380,node2=http://172.14.14.127:2380,node3=http://172.14.14.128:2380
initial-cluster-state: new
data-dir: /var/lib/etcd
listen-peer-urls: http://172.14.14.120:2380
listen-client-urls: http://172.14.14.120:2379
```

Start etcd:

```id="48c3wo"
systemctl enable --now etcd
```

---

## 6. Configure Patroni

Create config:

```id="shnh07"
mkdir -p /etc/patroni
vim /etc/patroni/patroni.yml
```

Basic configuration:

```id="spu8q2"
scope: cluster_1
namespace: percona_lab

postgresql:
  listen: 0.0.0.0:5432
  data_dir: /var/lib/pgsql/14/data
  authentication:
    superuser:
      username: postgres
      password: postgres
```

---

## 7. Start Patroni

```id="t6eqn3"
systemctl daemon-reload
systemctl enable --now patroni
systemctl status patroni
```

Check cluster:

```id="k1ny0h"
patronictl -c /etc/patroni/patroni.yml list
```

---

## 8. Configure HAProxy

Install:

```id="tqrb8v"
dnf install -y haproxy
```

Edit config:

```id="pj60g9"
vim /etc/haproxy/haproxy.cfg
```

Add:

```id="kl8b39"
listen postgres
  bind *:5432
  mode tcp
  balance roundrobin
  server node1 node1:5432 check
  server node2 node2:5432 check
  server node3 node3:5432 check
```

Start HAProxy:

```id="np50ve"
systemctl enable haproxy
systemctl start haproxy
```

---

## 9. Testing High Availability

* Stop primary node → verify failover
* Connect via HAProxy → ensure continuity

---

## ✅ Conclusion

Highly Available PostgreSQL cluster successfully configured using Patroni, Etcd, and HAProxy.

The system supports automatic failover and load balancing.
