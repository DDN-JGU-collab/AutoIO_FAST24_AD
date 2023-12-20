#!/bin/sh

# 10 nodes IO500 IOR-easy
LCTL=$(which lctl)

run_base_bio() {
    # Clear ldlm lock stats
    clush -w ai400x2-1-vm[1-4] $LCTL set_param obdfilter.*.exports.*.ldlm_stats=clear
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-iohardonly.ini
    # Collect the ldlm blocking AST stats
    clush -w ai400x2-1-vm[1-4] lctl get_param obdfilter.*.exports.*@o2ib12.ldlm_stats | awk '/ldlm_bl_callback/ { sum += $3 } END { printf("%0.0f\n", sum)}'
    # full writes stats
    clush -w ai400x2-1-vm[1-4] lctl get_param osd-ldiskfs.*.stats | awk '/full_writes/ { sum += $3 } END { print("%0.0f\n", sum) }'
}

run_base_dio() {
    # Clear ldlm lock stats
    clush -w ai400x2-1-vm[1-4] $LCTL set_param obdfilter.*.exports.*.ldlm_stats=clear
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-iorhardonly-odirect.ini
    # Collect the ldlm blocking AST stats
    clush -w ai400x2-1-vm[1-4] lctl get_param obdfilter.*.exports.*@o2ib12.ldlm_stats | awk '/ldlm_bl_callback/ { sum += $3 } END { printf("%0.0f\n", sum)}'
    # full writes stats
    clush -w ai400x2-1-vm[1-4] lctl get_param osd-ldiskfs.*.stats | awk '/full_writes/ { sum += $3 } END { print("%0.0f\n", sum) }'

}

run_bio_srv_wb() {
    # Enable server-side writeback on OSD ldiskfs
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.writeback_max_io_kb=64
    # Enable client-side batch writes
    clush -w ec[01-10] $LCTL set_param osc.*.batch_write_enabled=1

    # Clear ldlm lock stats
    clush -w ai400x2-1-vm[1-4] $LCTL set_param obdfilter.*.exports.*.ldlm_stats=clear
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-iohardonly.ini
    # Collect the ldlm blocking AST stats
    clush -w ai400x2-1-vm[1-4] lctl get_param obdfilter.*.exports.*@o2ib12.ldlm_stats | awk '/ldlm_bl_callback/ { sum += $3 } END { printf("%0.0f\n", sum)}'
    # full writes stats
    clush -w ai400x2-1-vm[1-4] lctl get_param osd-ldiskfs.*.stats | awk '/full_writes/ { sum += $3 } END { print("%0.0f\n", sum) }'
}

run_dio_srv_wb() {
    # Enable server-side writeback on OSD ldiskfs
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.writeback_max_io_kb=64
    # Enable client-side batch writes
    clush -w ec[01-10] $LCTL set_param osc.*.batch_write_enabled=1

    # Clear ldlm lock stats
    clush -w ai400x2-1-vm[1-4] $LCTL set_param obdfilter.*.exports.*.ldlm_stats=clear
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-iorhardonly-odirect.ini
    # Collect the ldlm blocking AST stats
    clush -w ai400x2-1-vm[1-4] lctl get_param obdfilter.*.exports.*@o2ib12.ldlm_stats | awk '/ldlm_bl_callback/ { sum += $3 } END { printf("%0.0f\n", sum)}'
    # full writes stats
    clush -w ai400x2-1-vm[1-4] lctl get_param osd-ldiskfs.*.stats | awk '/full_writes/ { sum += $3 } END { print("%0.0f\n", sum) }'

}

run_autoio_delalloc() {
    # Enable client-side autoIO on 10 nodes
    clush -w ec[01-10] $LCTL set_param llite.*.bio_as_dio=1
    # Enable client-side batch writes
    clush -w ec[01-10] $LCTL set_param osc.*.batch_write_enabled=1
    # Enable server-side writeback on OSD ldiskfs
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.writeback_max_io_kb=64
    # Enable delayed allocation
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.range_delalloc_enable=1
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.range_delalloc_work_enable=1

    # Clear ldlm lock stats
    clush -w ai400x2-1-vm[1-4] $LCTL set_param obdfilter.*.exports.*.ldlm_stats=clear
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-iohardonly.ini
    # Collect the ldlm blocking AST stats
    clush -w ai400x2-1-vm[1-4] lctl get_param obdfilter.*.exports.*@o2ib12.ldlm_stats | awk '/ldlm_bl_callback/ { sum += $3 } END { printf("%0.0f\n", sum)}'
    # full writes stats
    clush -w ai400x2-1-vm[1-4] lctl get_param osd-ldiskfs.*.stats | awk '/full_writes/ { sum += $3 } END { print("%0.0f\n", sum) }'
}

# runs base buffered I/O only as an example
run_base_bio