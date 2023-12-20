#!/bin/sh

# dcp a large single file with 4TiB with 32 nodes 16 np

LCTL=$(which lctl)
LFS=$(which lfs)
AUTOIOSTATS="../autoiostats.sh"
tfile="/exafs/s8/largefile"

mkdir -p /exafs/s8
$LFS setstripe -C 8 /exafs/s8

fallocate -l 4096g $tfile

clush -w ai400x2-1-vm[1-4] -w ec[01-32] "echo 3 > /proc/sys/vm/drop_caches"
clush -w ec[01-32] $LCTL set_param ldlm.namespaces.*.lru_size=clear

# dcp with the default buffered I/O mode
# Clear ldlm lock stats on all OSTs
clush -w ai400x2-1-vm[1-4] $LCTL set_param obdfilter.*.exports.*.ldlm_stats=clear
salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/dcp1 -b 4M -k 4M /exafs/s8/largefile /exafs/s8/tf
# Collect the ldlm blocking callback stats
echo "ldlm_bl_callback:"
clush -w ai400x2-1-vm[1-4] lctl get_param obdfilter.*.exports.*@o2ib12.ldlm_stats | awk '/ldlm_bl_callback/ { sum += $3 } END { printf("%0.0f\n", sum)}'
rm -rf /exafs/s8/tf

# dcp with autoIO
# Enable autoIO on 32 clients
clush -w ec[01-32] $LCTL set_param llite.*.bio_as_dio=1
clush -w ec[01-32] $LCTL set_param llite.*.stats=clear
# Clear ldlm lock stats on all OSTs
clush -w ai400x2-1-vm[1-4] $LCTL set_param obdfilter.*.exports.*.ldlm_stats=clear
salloc -p 40n --nodelist=ec[01-32] -N 32 --ntasks-per-node=16 /usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root /work/qian/IOPerf/mpiFileUtils/install/bin/dcp1 -b 4M -k 4M /exafs/s8/largefile /exafs/s8/tf
echo "ldlm_bl_callback:"
clush -w ai400x2-1-vm[1-4] lctl get_param obdfilter.*.exports.*@o2ib12.ldlm_stats | awk '/ldlm_bl_callback/ { sum += $3 } END { printf("%0.0f\n", sum)}'
sh $AUTOIOSTATS
