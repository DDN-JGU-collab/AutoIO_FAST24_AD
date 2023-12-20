#!/bin/sh

# Build Lustre server RPMs from source code with autoIO patch series
git clone git://git.whamcloud.com/fs/lustre-release.git lustre-release_client
cd lustre-release_client
# pull and check out the client-side patch series against Lustre source git.
# The tompose patch is: https://review.whamcloud.com/#/c/fs/lustre-release/+/52200/12
git fetch "https://review.whamcloud.com/fs/lustre-release" refs/changes/00/52200/5 && git cherry-pick FETCH_HEAD
sh autogen.sh
./configure --disable-server #--with-o2ib=/usr/src/ofa_kernel/default
make rpms

# Install and build Lustre packages on the client side
rpm -ivh *.rpm

# Configure a Lustre file system (client side) and mount it
mkdir -p /exafs
mount.lustre 10.2.0.1@tcp:/lustre /exafs