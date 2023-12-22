#!/bin/sh

# restart the client nodes with gived I/O mode
# tuneFileCacheType = buffered | native
mode=$1
conf="/etc/beegfs/beegfs-client.conf"

sh client_umountall.sh
clush -w ec[01-32] sed -i "/^tuneFileCacheType /s/=.*$/=$mode/" $conf
sh client_mountall.sh
