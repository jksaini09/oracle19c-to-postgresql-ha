# Ora2Pg Installation and Oracle to PostgreSQL Migration

## 1. Install Oracle Instant Client (Required for Ora2Pg)

### Download RPM Packages

```id="gqscvd"
wget https://download.oracle.com/otn_software/linux/instantclient/1919000/oracle-instantclient19.19-basic-19.19.0.0.0-1.x86_64.rpm
wget https://download.oracle.com/otn_software/linux/instantclient/1919000/oracle-instantclient19.19-devel-19.19.0.0.0-1.x86_64.rpm
wget https://download.oracle.com/otn_software/linux/instantclient/1919000/oracle-instantclient19.19-sqlplus-19.19.0.0.0-1.x86_64.rpm
```

---

### Install Instant Client

```id="b6a3xq"
dnf install -y oracle-instantclient19.19-*.rpm
```

---

### Configure Environment

```id="19xjgp"
export ORACLE_HOME=/usr/lib/oracle/19.19/client64
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:$PATH
```

---

## 2. Install Perl and Dependencies

```id="am20pb"
dnf install -y perl perl-DBI perl-DBD-Pg perl-ExtUtils-MakeMaker gcc make wget tar
```

Verify:

```id="e8zdrg"
perl -MDBI -e 'print "DBI OK\n"'
perl -MDBD::Pg -e 'print "DBD::Pg OK\n"'
```

---

## 3. Install DBD::Oracle

```id="df33ws"
cpan
```

Inside CPAN:

```id="22b1po"
install DBD::Oracle
```

Verify:

```id="5cr24r"
perl -MDBD::Oracle -e 'print "DBD::Oracle OK\n"'
```

---

## 4. Install Ora2Pg

```id="gmh7h4"
cd /opt
wget https://github.com/darold/ora2pg/archive/refs/tags/v24.3.tar.gz
tar -xzf v24.3.tar.gz
mv ora2pg-24.3 ora2pg
cd ora2pg
perl Makefile.PL
make
make install
```

Verify:

```id="6st5f2"
ora2pg --version
```

---

## 5. Configure Ora2Pg

Create project:

```id="e1lj6l"
cd /opt/ora2pg
ora2pg --init ora2pg_project
```

Edit config:

```id="2krrw8"
vim /opt/ora2pg/ora2pg_project/config/ora2pg.conf
```

Update:

```id="rsw5fh"
ORACLE_DSN dbi:Oracle:host=172.16.16.159;service_name=orclpdb1;port=1521
ORACLE_USER miguser
ORACLE_PWD password123

PG_DSN dbi:Pg:dbname=migdb;host=127.0.0.1;port=5432
PG_USER postgres
PG_PWD postgres

EXPORT_DIR /home/oracle/ora2pg/export
```

---

## 6. Export Schema

```id="q5ssqq"
mkdir -p /home/oracle/ora2pg/export

ora2pg -t TABLE \
-c /opt/ora2pg/ora2pg_project/config/ora2pg.conf \
-o schema.sql
```

Load schema into PostgreSQL:

```id="1nkmhp"
psql -U postgres -d migdb -f schema.sql
```

---

## 7. Export Data

Update config:

```id="0w9z3k"
TYPE DATA
FILE_PER_TABLE 1
```

Run:

```id="vy1y6u"
ora2pg -t DATA \
-c /opt/ora2pg/ora2pg_project/config/ora2pg.conf \
-b /home/oracle/ora2pg/export
```

---

## 8. Load Data into PostgreSQL

```id="d3rznh"
psql -U miguser -d migdb -f data.sql
```

---

## 9. Validation

Check data:

```id="x3knb1"
SELECT COUNT(*) FROM test_table;
```

---

## ✅ Conclusion

Ora2Pg migration successfully completed from Oracle 19c to PostgreSQL 14.

Schema and data have been migrated and validated.
