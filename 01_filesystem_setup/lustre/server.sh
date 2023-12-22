#!/bin/sh

# Build Lustre server RPMs from source code with autoIO patch series
git clone git://git.whamcloud.com/fs/lustre-release.git lustre-release_server
cd lustre-release_server
# pull and check out the server-side patch series against Lustre source git.
# The topmost patch is: https://review.whamcloud.com/#/c/fs/lustre-release/+/51159/6
git fetch "https://review.whamcloud.com/fs/lustre-release" refs/changes/59/51159/6 && git checkout FETCH_HEAD
sh autogen.sh
./configure #--with-o2ib=/usr/src/ofa_kernel/default
make rpms
cd ..

mkdir e2fsprogs
# https://wiki.lustre.org/Installing_the_Lustre_Software
# Download the latest e2fsprogs RPM packages from the URL:
# https://downloads.whamcloud.com/public/e2fsprogs/latest/el8/RPMS/x86_64/
wget https://downloads.whamcloud.com/public/e2fsprogs/latest/el8/RPMS/x86_64/e2fsprogs-1.47.0-wc4.el8.x86_64.rpm
wget https://downloads.whamcloud.com/public/e2fsprogs/latest/el8/RPMS/x86_64/e2fsprogs-devel-1.47.0-wc4.el8.x86_64.rpm
wget https://downloads.whamcloud.com/public/e2fsprogs/latest/el8/RPMS/x86_64/e2fsprogs-static-1.47.0-wc4.el8.x86_64.rpm
wget https://downloads.whamcloud.com/public/e2fsprogs/latest/el8/RPMS/x86_64/libcom_err-1.47.0-wc4.el8.x86_64.rpm
wget https://downloads.whamcloud.com/public/e2fsprogs/latest/el8/RPMS/x86_64/libss-1.47.0-wc4.el8.x86_64.rpm
rpm -ivh --force *.rpm

# Install built Lustre packages on the server side
cd ../lustre-release_server
rpm -ivh lustre-osd-ldiskfs-mount-*.el8.x86_64.rpm
rpm -ivh kmod-lustre-*.el8.x86_64.rpm
rpm -ivh kmod-lustre-osd-ldiskfs-*.el8.x86_64.rpm
rpm -ivh kmod-lustre-tests-*.el8.x86_64.rpm
rpm -ivh lustre-*.el8.x86_64.rpm
rpm -ivh lustre-iokit-*.el8.x86_64.rpm
rpm -ivh lustre-tests-*.el8.x86_64.rpm

# Configure a Lustre file system (server side) and mount the mdt and osts
# MDT:
mkfs.lustre --fsname=lustre --mgs --mdt --index=0 /dev/sda
mkdir -p /mnt/lustre-mdt
mount.lustre /dev/sda /mnt/lustre-mdt

# OST1:
mkfs.lustre --fsname=lustre --mgsnode=10.2.0.1@tcp --ost --index=0 /dev/sdc
mkdir -p /mnt/lustre-ost0
mount.lustre /dev/sdc /mnt/lustre-ost0

# OST2:
mkfs.lustre --fsname=lustre --mgsnode=10.2.0.1@tcp --ost --index=1 /dev/sdd
mkdir -p /mnt/lustre-ost1
mount.lustre /dev/sdd /mnt/lustre-ost1

