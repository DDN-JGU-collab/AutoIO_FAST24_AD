#!/bin/sh

# VPICIO benchmark: https://h5bench.readthedocs.io/en/latest/vpic.html
# Howto compile and install H5bench VPIC-IO benchmark:
# https://h5bench.readthedocs.io/en/latest/buildinstructions.html

fstype="orangefs"
dir="/mnt/orangefs/s8"
# `01_filesystem_setup/orangefs/server/server_restart_iomode.sh`
MOUNT_IOMODE="server_restart_iomode.sh"

run_iomode_one() {
	local mode=$1

	$MOUNT_IOMODE $mode
	# cfg/h5bench1m.cfg
	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_write /work/qian/vpic/cfg/h5bench1m.cfg $dir/test.1m.h5 | tee result/$fstype/$mode.w1m2s.log
	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_read /work/qian/vpic/cfg/h5bench1m.cfg $dir/test.1m.h5 | tee result/$fstype/$mode.r1m2s.log

	clush -w ai400x2-1-vm[1-4] -w ec[01-32] "echo 3 > /proc/sys/vm/drop_caches"

	# cfg/h5bench32k.cfg
	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_write /work/qian/vpic/cfg/h5bench32k.cfg $dir/test.32k.h5 | tee result/$fstype/$mode.w32k2s.log
	salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_read /work/qian/vpic/cfg/h5bench32k.cfg $dir/test.32k.h5 | tee result/$fstype/$mode.r32k2s.log

	rm $dir/*
}

# runs io mode altaio only as an example
run_iomode_one "alt-aio"
# run_iomode_one "directio"
