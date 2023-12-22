#!/bin/sh
sh cleanup.sh
clush -w ai400x2-1-vm[1-4] mkdir -p /mnt/beefs_meta/orangefs
clush -w ai400x2-1-vm[1-4] rm -rf /mnt/orangefs_meta/orangefs/*

clush -w ai400x2-1-vm1 mkdir -p /mnt/orangefs_storage0/orangefs
clush -w ai400x2-1-vm1 mkdir -p /mnt/orangefs_storage1/orangefs
clush -w ai400x2-1-vm1 rm -rf /mnt/orangefs_storage0/orangefs/*
clush -w ai400x2-1-vm1 rm -rf /mnt/orangefs_storage1/orangefs/*

clush -w ai400x2-1-vm1 mkdir -p /mnt/orangefs_storage2/orangefs
clush -w ai400x2-1-vm1 mkdir -p /mnt/orangefs_storage3/orangefs
clush -w ai400x2-1-vm2 rm -rf /mnt/orangefs_storage2/orangefs/*
clush -w ai400x2-1-vm2 rm -rf /mnt/orangefs_storage3/orangefs/*

clush -w ai400x2-1-vm1 mkdir -p /mnt/orangefs_storage4/orangefs
clush -w ai400x2-1-vm1 mkdir -p /mnt/orangefs_storage5/orangefs
clush -w ai400x2-1-vm3 rm -rf /mnt/orangefs_storage4/orangefs/*
clush -w ai400x2-1-vm3 rm -rf /mnt/orangefs_storage5/orangefs/*

clush -w ai400x2-1-vm1 mkdir -p /mnt/orangefs_storage6/orangefs
clush -w ai400x2-1-vm1 mkdir -p /mnt/orangefs_storage7/orangefs
clush -w ai400x2-1-vm4 rm -rf /mnt/orangefs_storage6/orangefs/*
clush -w ai400x2-1-vm4 rm -rf /mnt/orangefs_storage7/orangefs/*

clush -w ai400x2-1-vm1 /work/qian/orangefs/server/opt/sbin/pvfs2-server -f /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm1-s1
clush -w ai400x2-1-vm1 /work/qian/orangefs/server/opt/sbin/pvfs2-server -f /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm1-s2

clush -w ai400x2-1-vm2 /work/qian/orangefs/server/opt/sbin/pvfs2-server -f /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm2-s1
clush -w ai400x2-1-vm2 /work/qian/orangefs/server/opt/sbin/pvfs2-server -f /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm2-s2

clush -w ai400x2-1-vm3 /work/qian/orangefs/server/opt/sbin/pvfs2-server -f /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm3-s1
clush -w ai400x2-1-vm3 /work/qian/orangefs/server/opt/sbin/pvfs2-server -f /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm3-s2

clush -w ai400x2-1-vm4 /work/qian/orangefs/server/opt/sbin/pvfs2-server -f /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm4-s1
clush -w ai400x2-1-vm4 /work/qian/orangefs/server/opt/sbin/pvfs2-server -f /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm4-s2
