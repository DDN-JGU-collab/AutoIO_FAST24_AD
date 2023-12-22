#!/bin/sh

# 01_filesystem_setup/beegfs/client/client_restart_iomode.sh
MOUNT_IOMODE="client_restart_iomode.sh"
src="/mnt/beegfs/dataset"
dst="/mnt/beegfs/dstmp"

cleanup() {
    	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/drm $dst
    	clush -w ai400x2-1-vm[1-4] -w ec[01-32] "echo 3 > /proc/sys/vm/drop_caches"
}

run_native() {
	$MOUNT_IOMODE "native"
	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/dcp1 -b 4M -k 4M $src $dst

	cleanup
}

run_buffered() {
	$MOUNT_IOMODE "buffered"
	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/dcp1 -b 4M -k 4M $src $dst

	cleanup
}

# runs native only as an example
run_native
# run_buffered