#!/bin/sh

# Local ldiskfs performance with various I/O sizes for buffered I/O (BIO) and
# direct I/O (DIO) for Figure 1

run_bio() {
	# BIO performance:
	echo "BIO local ldiskfs performance:"
	for bs in "4K 16K 256K 1M 4M 16M 64M 256M"; do
		echo 3 > /proc/sys/vm/drop_caches
		fio -name test --directory=/mnt/ldiskfs/ior/fiodir --size 20g --ioengine psync --rw write --bs $bs --numjobs=16 -iodepth=8
		echo 3 > /proc/sys/vm/drop_caches
		fio -name test --directory=/mnt/ldiskfs/ior/fiodir --size 20g --ioengine psync --rw read --bs $bs --numjobs=16 -iodepth=8
	done
}

run_dio() {
	# DIO performance:
	echo "DIO local ldiskfs performance:"
	for bs in "4K 16K 256K 1M 4M 16M 64M 256M"; do
		fio -name test --directory=/mnt/ldiskfs/ior/fiodir --size 20g --ioengine psync --rw write --bs $bs -direct=1 --numjobs=16 -iodepth=8
		fio -name test --directory=/mnt/ldiskfs/ior/fiodir --size 20g --ioengine psync --rw read --bs $bs -driect=1 --numjobs=16 -iodepth=8
	done
}

run_bio
#run_dio