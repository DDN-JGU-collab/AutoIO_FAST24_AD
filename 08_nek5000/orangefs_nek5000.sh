#!/bin/sh

# Nek5000 benchmark
# `01_filesystem_setup/orangefs/server/server_restart_iomode.sh`
MOUNT_IOMODE="server_restart_iomode.sh"

run_iomode_one() {
	local mode=$1

	$MOUNT_IOMODE $mode
	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -x LD_PRELOAD=/work/qian/Darshan/install/lib/libdarshan.so -x DARSHAN_CONFIG_PATH=/work/qian/Darshan/darshan.conf /work/qian/Nek5000/Nek5000_workload/turbPipe/run/nek5000
}

# runs alt-aio mode only as an example
run_iomode_one "alt-aio"
# run_iomode_one "directio"
