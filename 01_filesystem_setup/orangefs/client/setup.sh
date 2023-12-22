#!/bin/sh
# See the following URLs about how to build orangeFS from source code (with IB support):
# - https://docs.orangefs.com/quickstart/quickstart-build/
# - https://docs.orangefs.com/build-configure/build_orangefs/
clush -w ec[01-32] insmod /work/qian/orangefs/client/kernel/orangefs/orangefs.ko
clush -w ec[01-32] mkdir -p /mnt/orangefs
clush -w ec[01-32] /work/qian/orangefs/client/opt/sbin/pvfs2-client -p /work/qian/orangefs/client/opt/sbin/pvfs2-client-core
clush -w ec[01-32] mount -t pvfs2 ib://10.0.11.208:3335/orangefs /mnt/orangefs
