#!/bin/bash
set -e

echo "==== Ora2Pg Migration Started ===="

# Set environment
export ORACLE_HOME=/usr/lib/oracle/19.19/client64
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:$PATH
export PERL5LIB=/opt/ora2pg/lib:$PERL5LIB

CONFIG_FILE="/opt/ora2pg/ora2pg_project/config/ora2pg.conf"
EXPORT_DIR="/home/oracle/ora2pg/export"

mkdir -p $EXPORT_DIR

echo "---- Exporting Schema ----"
ora2pg -t TABLE \
-c $CONFIG_FILE \
-o schema.sql

echo "---- Loading Schema into PostgreSQL ----"
psql -U postgres -d migdb -f schema.sql

echo "---- Exporting Data ----"
ora2pg -t DATA \
-c $CONFIG_FILE \
-b $EXPORT_DIR

echo "---- Loading Data ----"
psql -U miguser -d migdb -f data.sql

echo "==== Migration Completed Successfully ===="
