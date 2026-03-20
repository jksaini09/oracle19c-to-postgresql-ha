#!/bin/bash
set -e

echo "==== HA Cluster Setup Started ===="

# Install required packages
dnf update -y
dnf install -y epel-release
dnf install -y percona-postgresql14-server percona-patroni etcd python3-python-etcd haproxy

# Stop services if running
systemctl stop postgresql-14 patroni etcd haproxy || true
systemctl disable postgresql-14 patroni etcd haproxy || true

# Enable services
systemctl enable etcd
systemctl enable patroni
systemctl enable haproxy

echo "---- Starting etcd ----"
systemctl start etcd

echo "---- Starting Patroni ----"
systemctl start patroni

echo "---- Starting HAProxy ----"
systemctl start haproxy

echo "---- Checking Cluster ----"
patronictl -c /etc/patroni/patroni.yml list || true

echo "==== HA Cluster Setup Completed ===="
