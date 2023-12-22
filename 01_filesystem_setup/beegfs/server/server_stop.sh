#!/bin/sh
systemctl stop beegfs-mgmtd
clush -a systemctl stop beegfs-meta
clush -a systemctl stop beegfs-storage

