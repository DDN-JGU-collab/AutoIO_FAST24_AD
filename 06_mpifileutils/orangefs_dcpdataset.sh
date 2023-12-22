#!/bin/sh

# `01_filesystem_setup/orangefs/server/server_restart_iomode.sh`
MOUNT_IOMODE="server_restart_iomode.sh"
src="/mnt/orangefs/dataset"
dst="/mnt/orangefs/dstmp"

cleanup() {
    	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/drm $dst
    	clush -w ai400x2-1-vm[1-4] -w ec[01-32] "echo 3 > /proc/sys/vm/drop_caches"
}

run_altaio() {
	$MOUNT_IOMODE "alt-aio"
	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/dcp1 -b 4M -k 4M $src $dst

	cleanup
}

run_directio() {
	$MOUNT_IOMODE "directio"
	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/dcp1 -b 4M -k 4M $src $dst

	cleanup
}

# runs native only as an example
run_altaio
