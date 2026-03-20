# PostgreSQL 14 Installation and Configuration (Target Database - VM2)

## 1. Pre-Installation System Configuration (Root User)

### 1.1 Disable SELinux

Edit:

```
/etc/selinux/config
```

Set:

```
SELINUX=disabled
```

Run:

```
setenforce 0
getenforce
```

---

### 1.2 Disable Firewall

```
systemctl stop firewalld
systemctl disable firewalld
```

---

### 1.3 OS Package Cleanup & Update

```
dnf clean all
dnf makecache
dnf update -y
```

---

## 2. Install PostgreSQL 14

### Disable default PostgreSQL module

```
dnf -qy module disable postgresql
```

---

### Install PostgreSQL repository

```
dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
```

---

### Install PostgreSQL 14 packages

```
dnf install -y postgresql14 postgresql14-server postgresql14-contrib
```

---

### Verify installation

```
psql --version
```

---

## 3. Initialize and Start PostgreSQL

```
/usr/pgsql-14/bin/postgresql-14-setup initdb
systemctl enable postgresql-14
systemctl start postgresql-14
systemctl status postgresql-14
```

---

## 4. Basic PostgreSQL Access Check

Switch to postgres user:

```
su - postgres
```

Run:

```
psql
\q
```

---

## 5. Create Target Database and User

Run as postgres:

```
CREATE DATABASE migdb;
CREATE USER miguser WITH PASSWORD 'migpass';
GRANT ALL PRIVILEGES ON DATABASE migdb TO miguser;
```

---

## 6. Configure pg_hba.conf

Edit:

```
/var/lib/pgsql/14/data/pg_hba.conf
```

Add:

```
local all miguser trust
host all miguser 127.0.0.1/32 trust
local all all trust
host all all 127.0.0.1/32 trust
host all all ::1/128 trust
```

Reload PostgreSQL:

```
systemctl reload postgresql-14
```

---

## 7. Test Database Connectivity

```
psql -U miguser -d migdb -h 127.0.0.1
```

---

## ✅ Conclusion

PostgreSQL 14 is successfully installed and configured.

The system is now ready for Ora2Pg migration.
