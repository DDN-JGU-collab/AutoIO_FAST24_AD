#!/bin/sh
clush -w ec[01-32] mount -t pvfs2 ib://10.0.11.208:3335/orangefs /mnt/orangefs
