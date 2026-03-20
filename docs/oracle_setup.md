# Oracle 19c Installation and Configuration (Source Database - VM1)

## 1. Pre-Installation System Configuration (Root User)

### 1.1 Disable SELinux

Edit configuration file:

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

## 2. Install Oracle Pre-installation RPM

Download package:

```
curl -o oracle-database-preinstall-19c-1.0-1.el9.x86_64.rpm \
https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/oracle-database-preinstall-19c-1.0-1.el9.x86_64.rpm
```

Install:

```
dnf localinstall -y oracle-database-preinstall-19c-1.0-1.el9.x86_64.rpm
```

Verify oracle user:

```
id oracle
```

Verify kernel parameters:

```
sysctl -a | egrep "shmmni|shmall|shmmax|sem|aio-max-nr"
```

---

## 3. Oracle Directory Structure

Create directories:

```
mkdir -p /opt/oracle/product/19c/dbhome_1
mkdir -p /u01/app/oraInventory
mkdir -p /u01/app/oracle
mkdir -p /u01/oradata
mkdir -p /u01/app/oracle/backup
```

Set ownership:

```
chown -R oracle:oinstall /opt/oracle
chown -R oracle:oinstall /u01/app/oracle
chown -R oracle:oinstall /u01/oradata
chown -R oracle:oinstall /u01/app/oraInventory
```

Set permissions:

```
chmod -R 775 /u01/app/oraInventory
chmod -R 775 /u01/app/oracle
chmod -R 775 /u01/oradata
```

---

## 4. Oracle Environment Configuration (oracle user)

Switch user:

```
su - oracle
```

Edit profile:

```
vim ~/.bash_profile
```

Add:

```
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/19c/dbhome_1
export ORACLE_SID=ORCLCDB
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
```

Reload:

```
source ~/.bash_profile
```

---

## 5. Oracle 19c Software Installation

Download Oracle 19c RPM from:
https://www.oracle.com/in/database/technologies/oracle19c-linux-downloads.html

Install:

```
dnf localinstall -y /tmp/oracle-database-ee-19c-1.0-1.x86_64.rpm
```

---

## 6. Database Configuration

Run as root:

```
/etc/init.d/oracledb_ORCLCDB-19c configure
```

Check service:

```
systemctl status oracledb_ORCLCDB-19c
```

---

## 7. Validation

Switch to oracle user:

```
su - oracle
```

Set environment:

```
export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=ORCLCDB
```

Connect to database:

```
sqlplus / as sysdba
```

Switch to PDB:

```
ALTER SESSION SET CONTAINER = ORCLPDB1;
show con_name;
```

Create migration user:

```
CREATE USER miguser IDENTIFIED BY password123;
GRANT CONNECT, RESOURCE TO miguser;
```

---

## ✅ Conclusion

Oracle 19c database is successfully installed and configured.

The system is now ready for migration using Ora2Pg.
