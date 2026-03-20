#!/bin/bash

# Oracle Pre-install
dnf clean all
dnf makecache
dnf update -y

dnf install -y oracle-database-preinstall-19c
