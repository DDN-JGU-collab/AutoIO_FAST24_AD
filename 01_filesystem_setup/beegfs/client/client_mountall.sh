#!/bin/sh

# Change the client configs on all clients: /etc/beegfs/beegfs-client.conf
# - tuneFileCacheType	= buffered # native or none
# - tuneFileCacheBufSize = 524288 # Default: 512KiB
clush -w ec[01-32] systemctl start beegfs-helperd
clush -w ec[01-32] systemctl start beegfs-client
