#!/bin/sh

# VPICIO benchmark: https://h5bench.readthedocs.io/en/latest/vpic.html
# Howto compile and install H5bench VPIC-IO benchmark:
# https://h5bench.readthedocs.io/en/latest/buildinstructions.html

LCTL=$(which lctl)
LFS=$(which lfs)
AUTOIOSTATS="./autoiostats.sh"

run_base_lustre() {
    #### buffered I/O ####
    # cfg/h5bench1m.cfg
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_write /work/qian/vpic/cfg/h5bench1m.cfg /exafs/s8/test.1m.h5 | tee result/lustre/bio.w1m2s.log
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_read /work/qian/vpic/cfg/h5bench1m.cfg /exafs/s8/test.1m.h5 | tee result/lustre/bio.r1m2s.log

    clush -w ai400x2-1-vm[1-4] -w ec[01-32] "echo 3 > /proc/sys/vm/drop_caches"
    clush -w ec[01-32] $LCTL set_param ldlm.namespaces.*.lru_size=clear

    # cfg/h5bench32k.cfg
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_write /work/qian/vpic/cfg/h5bench32k.cfg /exafs/s8/test.32k.h5 | tee result/lustre/bio.w32k2s.log
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_read /work/qian/vpic/cfg/h5bench32k.cfg /exafs/s8/test.32k.h5 | tee result/lustre/bio.r32k2s.log
}

run_autoio() {
    ##### autoIO #####
    # Enable client-side autoIO on 10 nodes
    clush -w ec[01-10] $LCTL set_param llite.*.bio_as_dio=1
    # Enable client-side batch writes
    clush -w ec[01-10] $LCTL set_param osc.*.batch_write_enabled=1
    # Enable server-side writeback on OSD ldiskfs
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.writeback_max_io_kb=64
    # Enable delayed allocation with server-side writeback
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.range_delalloc_enable=1
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.range_delalloc_work_enable=1

    # cfg/h5bench1m.cfg
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_write /work/qian/vpic/cfg/h5bench1m.cfg /exafs/s8/test.1m.h5 | tee result/lustre/bio.w1m2s.log
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_read /work/qian/vpic/cfg/h5bench1m.cfg /exafs/s8/test.1m.h5 | tee result/lustre/bio.r1m2s.log

    clush -w ai400x2-1-vm[1-4] -w ec[01-32] "echo 3 > /proc/sys/vm/drop_caches"
    clush -w ec[01-32] $LCTL set_param ldlm.namespaces.*.lru_size=clear

    # cfg/h5bench32k.cfg
    clush -w ec[01-32] $LCTL set_param llite.*.stats=clear
    # Clear ldlm lock stats on all OSTs
    clush -w ai400x2-1-vm[1-4] $LCTL set_param obdfilter.*.exports.*.ldlm_stats=clear
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_write /work/qian/vpic/cfg/h5bench32k.cfg /exafs/s8/test.32k.h5 | tee result/lustre/bio.w32k2s.log
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/vpic/h5bench/build/h5bench_read /work/qian/vpic/cfg/h5bench32k.cfg /exafs/s8/test.32k.h5 | tee result/lustre/bio.r32k2s.log
    # stats for DLM lock blocking callbacks
    clush -w ai400x2-1-vm[1-4] lctl get_param obdfilter.*.exports.*@o2ib12.ldlm_stats | awk '/ldlm_bl_callback/ { sum += $3 } END { printf("%0.0f\n", sum)}'
    # autoIO stats
    sh $AUTOIOSTATS
    # OSD ldiskfs (server side) full writes stats:
    clush -w ai400x2-1-vm[1-4] lctl get_param osd-ldiskfs.*.stats | awk '/full_writes/ { sum += $3 } END { print("%0.0f\n", sum) }'
}

# runs run_base_lustre only as an example
run_base_lustre