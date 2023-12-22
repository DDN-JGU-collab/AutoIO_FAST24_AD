# !/bin/sh
# Single I/O stream throughtput (buffered I/O)

tfile="/mnt/beegfs/s8/test"
dir="/mnt/beegfs/s8"
logdir="output/singlestream/beegfs"
# 01_filesystem_setup/beegfs/client/client_restart_iomode.sh
MOUNT_IOMODE="client_restart_iomode.sh"

mkdir $dir
beegfs-ctl --setpattern --numtargets=8 --chunksize=1M $dir
mkdir -p $logdir

test_one() {
	local bs=$1
	local sz=$2
	local logf=$3
	local direct=$4

	echo 3 > /proc/sys/vm/drop_caches
	clush -w ai400x2-1-vm[1-4] "echo 3 > /proc/sys/vm/drop_caches"
	sleep 1
	echo "========= ior test: bs=$1 ============"
	/work/tools/bin/ior -t $bs -b $sz -k -E -e -w -r -F $direct -o $tfile >> $logf
	rm -rf $dir/*
}

run_native_bio() {
	echo "Benchmark Buffered I/O performance for a single stream I/O"
	logfile="$logdir/ior.singlestream.BIO.native.log"

	# Switch to beeGFS native I/O mode on clients
	$MOUNT_IOMODE "native"
	test_one "4K" "200g" $logfile
	test_one "16K" "200g" $logfile
	test_one "64K" "200g" $logfile
	test_one "256K" "200g" $logfile
	test_one "1M" "200g" $logfile
	test_one "4M" "200g" $logfile
	test_one "16M" "200g" $logfile
	test_one "64M" "200g" $logfile
	test_one "256M" "200g" $logfile
}

run_buffered_bio() {
	echo "Benchmark Buffered I/O performance for a single stream I/O"
	logfile="$logdir/ior.singlestream.BIO.buffered.log"

	# Switch to beeGFS buffered I/O mode on clients
	$MOUNT_IOMODE "buffered"
	test_one "4K" "200g" $logfile
	test_one "16K" "200g" $logfile
	test_one "64K" "200g" $logfile
	test_one "256K" "200g" $logfile
	test_one "1M" "200g" $logfile
	test_one "4M" "200g" $logfile
	test_one "16M" "200g" $logfile
	test_one "64M" "200g" $logfile
	test_one "256M" "200g" $logfile
}

run_base_dio() {
	echo "Benchmark direct I/O performance for a single stream I/O"
	logfile="$logdir/ior.singlestream.DIO.log"
	test_one "4K" "200g" $logfile "--posix.odirect"
	test_one "16K" "200g" $logfile "--posix.odirect"
	test_one "64K" "200g" $logfile "--posix.odirect"
	test_one "256K" "200g" $logfile "--posix.odirect"
	test_one "1M" "200g" $logfile "--posix.odirect"
	test_one "4M" "200g" $logfile "--posix.odirect"
	test_one "16M" "200g" $logfile "--posix.odirect"
	test_one "64M" "200g" $logfile "--posix.odirect"
	test_one "256M" "200g" $logfile "--posix.odirect"
}

# runs native bio only as an example
run_native_bio
