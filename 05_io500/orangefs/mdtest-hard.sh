#!/bin/sh

# `01_filesystem_setup/orangefs/server/server_restart_iomode.sh`
MOUNT_IOMODE="server_restart_iomode.sh"

# 10 nodes IO500 mdtest-hard
run_altaio() {
	$MOUNT_IOMODE "alt-aio"
	salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500-orangefs.sh config-mdtesthard.ini
}

run_directio() {
	$MOUNT_IOMODE "directio"
	salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500-orangefs.sh config-mdtesthard.ini
}

# runs altaio only as an example
run_altaio
# run_directio