#!/bin/sh

# reformat the filesystem
rm -rf /mnt/beegfs_mgmtd/data
clush -a rm -rf /mnt/beegfs_meta/data
rm -rf /mnt/beegfs_storage0/data
rm -rf /mnt/beegfs_storage1/data
clush -w ai400x2-1-vm2 rm -rf /mnt/beegfs_storage2/data
clush -w ai400x2-1-vm2 rm -rf /mnt/beegfs_storage3/data
clush -w ai400x2-1-vm3 rm -rf /mnt/beegfs_storage4/data
clush -w ai400x2-1-vm3 rm -rf /mnt/beegfs_storage5/data
clush -w ai400x2-1-vm4 rm -rf /mnt/beegfs_storage6/data
clush -w ai400x2-1-vm4 rm -rf /mnt/beegfs_storage7/data

clush -w ai400x2-1-vm1 mkdir /mnt/beegfs_mgmtd/data
clush -w ai400x2-1-vm1 mkdir /mnt/beegfs_meta/data /mnt/beegfs_storage0/data /mnt/beegfs_storage1/data
clush -w ai400x2-1-vm2 mkdir /mnt/beegfs_meta/data /mnt/beegfs_storage2/data /mnt/beegfs_storage3/data
clush -w ai400x2-1-vm3 mkdir /mnt/beegfs_meta/data /mnt/beegfs_storage4/data /mnt/beegfs_storage5/data
clush -w ai400x2-1-vm4 mkdir /mnt/beegfs_meta/data /mnt/beegfs_storage6/data /mnt/beegfs_storage7/data

