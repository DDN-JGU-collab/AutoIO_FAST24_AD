#!/bin/sh

clush -w ai400x2-1-vm1 /work/qian/orangefs/server/opt/sbin/pvfs2-server /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm1-s1
clush -w ai400x2-1-vm1 /work/qian/orangefs/server/opt/sbin/pvfs2-server /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm1-s2

clush -w ai400x2-1-vm2 /work/qian/orangefs/server/opt/sbin/pvfs2-server /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm2-s1
clush -w ai400x2-1-vm2 /work/qian/orangefs/server/opt/sbin/pvfs2-server /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm2-s2

clush -w ai400x2-1-vm3 /work/qian/orangefs/server/opt/sbin/pvfs2-server /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm3-s1
clush -w ai400x2-1-vm3 /work/qian/orangefs/server/opt/sbin/pvfs2-server /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm3-s2

clush -w ai400x2-1-vm4 /work/qian/orangefs/server/opt/sbin/pvfs2-server /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm4-s1
clush -w ai400x2-1-vm4 /work/qian/orangefs/server/opt/sbin/pvfs2-server /work/qian/orangefs/server/opt/etc/orangefs-server.conf -a ai400x2-1-vm4-s2
