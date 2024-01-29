#!/bin/sh

# 10 nodes IO500 IOR-easy
LCTL=$(which lctl)

run_base() {
    # Lustre vanilla case
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-ioreasyonly.ini
}

run_autoIO() {
    # Enable client-side autoIO on 10 nodes
    clush -w ec[01-10] $LCTL set_param llite.*.bio_as_dio=1
    salloc -p 10n --nodelist=ec[01-10] -N 10 --ntasks-per-node=16 /work/BMLab/Lustre/io500/io500.git/io500.sh config-ioreasyonly.ini
}

# runs base only as an example
run_base
# run_autoIO