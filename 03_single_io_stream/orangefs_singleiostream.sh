# !/bin/sh
# Single I/O stream throughtput (buffered I/O)

tfile="/mnt/orangefs/s8/test"
dir="/mnt/orangefs/s8"
logdir="output/singlestream/orangefs"
# `01_filesystem_setup/orangefs/server/server_restart_iomode.sh`
MOUNT_IOMODE="server_restart_iomode.sh"

mkdir $dir
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

run_altaio_bio() {
	echo "Benchmark Buffered I/O performance for a single stream I/O"
	logfile="$logdir/ior.singlestream.BIO.altaio.log"

	# Switch to orangefs alt-aio I/O mode on servers
	$MOUNT_IOMODE "alt-aio"
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

run_altaio_dio() {
	echo "Benchmark Buffered I/O performance for a single stream I/O"
	logfile="$logdir/ior.singlestream.DIO.altaio.log"

	# Switch to orangefs alt-aio I/O mode on servers
	$MOUNT_IOMODE "alt-aio"
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

run_directio_bio() {
	echo "Benchmark Buffered I/O performance for a single stream I/O"
	logfile="$logdir/ior.singlestream.BIO.directio.log"

	# Switch to orangefs directio I/O mode on servers
	$MOUNT_IOMODE "directio"
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

run_directio_dio() {
	echo "Benchmark direct I/O performance for a single stream I/O"
	logfile="$logdir/ior.singlestream.DIO.directio.log"

	# Switch to orangefs directio I/O mode on servers
	$MOUNT_IOMODE "directio"
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

# runs alt-aio bio only as an example
run_altaio_bio
# run_altaio_dio
# run_directio_bio
# run_directio_dio