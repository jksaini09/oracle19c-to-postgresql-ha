# oracle19c-to-postgresql-ha
Oracle 19c to PostgreSQL 14 migration using Ora2Pg with HA cluster (Patroni + HAProxy)
## ▶️ How to Run the Scripts

### Make scripts executable

```bash
chmod +x src/scripts/*.sh
```

### Install PostgreSQL

```bash
./src/scripts/postgres_install.sh
```

### Run Ora2Pg Migration

```bash
./src/scripts/ora2pg_migration.sh
```

### Setup HA Cluster

```bash
./src/scripts/ha_cluster_setup.sh
```
