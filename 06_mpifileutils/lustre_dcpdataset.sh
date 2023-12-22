#!/bin/sh

LCTL=$(which lctl)
LFS=$(which lfs)

cleanup() {
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/drm /exafs/dstmp
    clush -w ai400x2-1-vm[1-4] -w ec[01-32] "echo 3 > /proc/sys/vm/drop_caches"
    clush -w ec[01-32] $LCTL set_param ldlm.namespaces.*.lru_size=clear
}

get_file_size_distribution () {
    # Obtain I/O size stats for the source dataset
    /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -np 32 /work/qian/IOPerf/mpiFileUtils/install/bin/dwalk -d size:32K,64K,100K,1M,2M,100M,1G,10G,100G,1000G /exafs/dataset/

    clush -w ai400x2-1-vm[1-4] -w ec[01-32] "echo 3 > /proc/sys/vm/drop_caches"
    clush -w ec[01-32] $LCTL set_param ldlm.namespaces.*.lru_size=clear
}

run_base_lustre() {
    # dcp with the default buffered I/O mode
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/dcp1 -b 4M -k 4M /exafs/dataset /exafs/dstmp

    cleanup
}

run_autoio() {
    # dcp with autoIO
    # Enable autoIO on 32 clients
    clush -w ec[01-32] $LCTL set_param llite.*.bio_as_dio=1
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/dcp1 -b 4M -k 4M /exafs/dataset /exafs/dstmp
    cleanup
}

run_autoio_batch_srvwb() {
    # dcp with autoIO, batching, and server-side write-back
    # Enable autoIO on 32 clients
    clush -w ec[01-32] $LCTL set_param llite.*.bio_as_dio=1
    # Setting largeio threshold with 512K (2MiB by default)
    clush -w ec[01-32] $LCTL set_param llite.*.swtich_dio_threshold=512K
    clush -w ec[01-32] $LCTL set_param osc.*.batch_write_enabled=1
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.writeback_max_io_kb=64K
    salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/dcp1 -b 4M -k 4M /exafs/dataset /exafs/dstmp
    cleanup
}

# runs get_file_size_distribution only as an example
get_file_size_distribution
