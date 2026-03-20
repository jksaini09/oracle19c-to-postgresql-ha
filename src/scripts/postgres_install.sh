#!/bin/bash
set -e

echo "==== PostgreSQL 14 Installation Started ===="

# Disable default PostgreSQL module
dnf -qy module disable postgresql

# Install PostgreSQL repo
dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Install PostgreSQL 14
dnf install -y postgresql14 postgresql14-server postgresql14-contrib

# Initialize DB
/usr/pgsql-14/bin/postgresql-14-setup initdb

# Enable and start service
systemctl enable postgresql-14
systemctl start postgresql-14

# Create DB and user
sudo -u postgres psql <<EOF
CREATE DATABASE migdb;
CREATE USER miguser WITH PASSWORD 'migpass';
GRANT ALL PRIVILEGES ON DATABASE migdb TO miguser;
EOF

echo "==== PostgreSQL Installation Completed ===="
