#!/bin/sh

clush -a yum localinstall -y /work/qian/beeGFS/release/beegfs-common-7.4.0p1-el8.noarch.rpm /work/qian/beeGFS/release/libbeegfs-ib-7.4.0p1-el8.x86_64.rpm /work/qian/beeGFS/release/beegfs-meta-7.4.0p1-el8.x86_64.rpm //work/qian/beeGFS/release/beegfs-storage-7.4.0p1-el8.x86_64.rpm

clush -w ai400x2-1-vm1 yum localinstall -y /work/qian/beeGFS/release/beegfs-mgmtd-7.4.0p1-el8.x86_64.rpm
