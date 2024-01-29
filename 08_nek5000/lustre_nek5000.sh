#!/bin/sh

# Nek5000 benchmark
LCTL=$(which lctl)
LFS=$(which lfs)
AUTOIOSTATS="./autoiostats.sh"

run_base_lustre() {
    # Lustre (default buffered I/O)
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -x LD_PRELOAD=/work/qian/Darshan/install/lib/libdarshan.so -x DARSHAN_CONFIG_PATH=/work/qian/Darshan/darshan.conf /work/qian/Nek5000/Nek5000_workload/turbPipe/run/nek5000
}

run_autoio() {
    # Lustre autoIO
    clush -w ec[01-32] $LCTL set_param llite.*.bio_as_dio=1
    clush -w ec[01-32] $LCTL set_param llite.*.stats=clear
    # Clear ldlm lock stats on all OSTs
    clush -w ai400x2-1-vm[1-4] $LCTL set_param obdfilter.*.exports.*.ldlm_stats=clear
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -x LD_PRELOAD=/work/qian/Darshan/install/lib/libdarshan.so -x DARSHAN_CONFIG_PATH=/work/qian/Darshan/darshan.conf /work/qian/Nek5000/Nek5000_workload/turbPipe/run/nek5000
    # stats for DLM lock blocking callbacks
    clush -w ai400x2-1-vm[1-4] lctl get_param obdfilter.*.exports.*@o2ib12.ldlm_stats | awk '/ldlm_bl_callback/ { sum += $3 } END { printf("%0.0f\n", sum)}'
    # autoIO stats
    sh $AUTOIOSTATS
}

run_autoio_srvwb() {
    # Lustre autoIO
    clush -w ec[01-32] $LCTL set_param llite.*.bio_as_dio=1
    clush -w ec[01-32] $LCTL set_param llite.*.stats=clear
    # Clear ldlm lock stats on all OSTs
    clush -w ai400x2-1-vm[1-4] $LCTL set_param obdfilter.*.exports.*.ldlm_stats=clear
    # Enable server-side writeback
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.writeback_max_io_kb=64K
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -x LD_PRELOAD=/work/qian/Darshan/install/lib/libdarshan.so -x DARSHAN_CONFIG_PATH=/work/qian/Darshan/darshan.conf /work/qian/Nek5000/Nek5000_workload/turbPipe/run/nek5000
    # stats for DLM lock blocking callbacks
    clush -w ai400x2-1-vm[1-4] lctl get_param obdfilter.*.exports.*@o2ib12.ldlm_stats | awk '/ldlm_bl_callback/ { sum += $3 } END { printf("%0.0f\n", sum)}'
    # autoIO stats
    sh $AUTOIOSTATS
}

# runs run_base_lustre only as an example
run_base_lustre
# run_autoio
# run_autoio_srvwb