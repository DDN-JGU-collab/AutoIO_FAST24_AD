#!/bin/sh

/opt/beegfs/sbin/beegfs-setup-mgmtd -p /mnt/beegfs_mgmtd/data

/opt/beegfs/sbin/beegfs-setup-meta -p /mnt/beegfs_meta/data -s 5 -m ai400x2-1-vm1
/opt/beegfs/sbin/beegfs-setup-storage -p /mnt/beegfs_storage0/data -s 1 -i 101 -m ai400x2-1-vm1
/opt/beegfs/sbin/beegfs-setup-storage -p /mnt/beegfs_storage1/data -s 1 -i 102


clush -w ai400x2-1-vm2 /opt/beegfs/sbin/beegfs-setup-meta -p /mnt/beegfs_meta/data -s 6 -m ai400x2-1-vm1
clush -w ai400x2-1-vm2 /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/beegfs_storage2/data -s 2 -i 201 -m ai400x2-1-vm1
clush -w ai400x2-1-vm2 /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/beegfs_storage3/data -s 2 -i 202


clush -w ai400x2-1-vm3 /opt/beegfs/sbin/beegfs-setup-meta -p /mnt/beegfs_meta/data -s 7 -m ai400x2-1-vm1
clush -w ai400x2-1-vm3 /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/beegfs_storage4/data -s 3 -i 301 -m ai400x2-1-vm1
clush -w ai400x2-1-vm3 /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/beegfs_storage5/data -s 3 -i 302


clush -w ai400x2-1-vm4 /opt/beegfs/sbin/beegfs-setup-meta -p /mnt/beegfs_meta/data -s 8 -m ai400x2-1-vm1
clush -w ai400x2-1-vm4 /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/beegfs_storage6/data -s 4 -i 401 -m ai400x2-1-vm1
clush -w ai400x2-1-vm4 /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/beegfs_storage7/data -s 4 -i 402
