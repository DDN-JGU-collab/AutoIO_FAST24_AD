#!/bin/sh

# 10 nodes IO500 mdtest-hard
LCTL=$(which lctl)

run_base() {
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-mdtesthard.ini
}

run_batch() {
    # Enable batch small writes on client side
    clush -w ec[01-10] $LCTL set_param mdc.*.batch_write_enabled=1
    clush -w ec[01-10] $LCTL set_param osd.*.batch_write_enabled=1
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-mdtesthard.ini
}

run_srv_wb() {
    # Enable OSD ldiskfs writeback (server side)
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.writeback_max_io_kb=64
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-mdtesthard.ini
}

run_batch_srv_wb() {
    # Enable batch small writes on client side
    clush -w ec[01-10] $LCTL set_param mdc.*.batch_write_enabled=1
    clush -w ec[01-10] $LCTL set_param osd.*.batch_write_enabled=1
    # Enable OSD ldiskfs writeback (server side)
    clush -w ai400x2-1-vm[1-4] $LCTL set_param osd-ldiskfs.*.writeback_max_io_kb=64
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-mdtesthard.ini
}

# runs base only as an example
run_base