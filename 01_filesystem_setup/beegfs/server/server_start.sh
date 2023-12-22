#!/bin/sh

systemctl start beegfs-mgmtd
clush -a systemctl start beegfs-meta
clush -a systemctl start beegfs-storage
