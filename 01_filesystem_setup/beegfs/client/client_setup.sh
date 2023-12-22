#!bin/sh

# Setup beeGFS clients
# See the following URLs for details:
# - https://doc.beegfs.io/latest/quick_start_guide/quick_start_guide.html#step-1-package-download-and-installation
# - https://doc.beegfs.io/latest/quick_start_guide/quick_start_guide.html

clush -w ec[01-32] /opt/beegfs/sbin/beegfs-setup-client -m ai400x2-1-vm1
sh client_mountall.sh
