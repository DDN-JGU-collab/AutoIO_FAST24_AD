#!/bin/sh

# 10 nodes IO500 IOR-easy
# 01_filesystem_setup/beegfs/client/client_restart_iomode.sh
MOUNT_IOMODE="client_restart_iomode.sh"

run_native() {
	$MOUNT_IOMODE "native"
	salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500-beegfs.sh config-ioreasyonly.ini
}

run_buffered() {
	$MOUNT_IOMODE "buffered"
	salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500-beegfs.sh config-ioreasyonly.ini
}

# runs native only as an example
run_native
# run_buffered
