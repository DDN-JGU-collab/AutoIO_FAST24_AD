# !/bin/sh
# Single I/O stream throughtput (buffered I/O)

tfile="/exafs/s8/test"
dir="/exafs/s8"
LFS=$(which lfs)
LCTL=$(which lctl)
logdir="output/singlestream/lustre"

mkdir $dir
$LFS setstripe -C 8 $dir
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

run_base_bio() {
	echo "Benchmark Buffered I/O performance for a single stream I/O"
	logfile="$logdir/ior.singlestream.BIO.log"
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

run_base_udio() {
	echo "Benchmark unaligned direct I/O performance for a single stream I/O"
	logfile="$logdir/ior.singlestream.UDIO.log"
	# iosize: 4K + 8
	test_one 4104 $((4104 * 256 * 1024 * 2)) $logfile "--posix.odirect"
	# iosize: 16K + 8
	test_one 16392 $((16392 * 64 * 1024 * 2)) $logfile "--posix.odirect"
	# iosize: 64K + 8
	test_one 65544 $((65544 * 16 * 1024 * 8)) $logfile "--posix.odirect"
	# iosize: 256K + 8
	test_one 262152 $((262152 * 4 * 1024 * 20)) $logfile "--posix.odirect"
	# iosize: 1M + 8
	test_one 1048584 $((1048584 * 1024 * 100)) $logfile "--posix.odirect"
	# iosize: 4M + 8
	test_one 4194312 $((4194312 * 1024 * 25)) $logfile "--posix.odirect"
	# iosize: 16M + 8
	test_one 16777224 $((16777224 * 256 * 25)) $logfile "--posix.odirect"
	# iosize: 64M + 8
	test_one 67108872 $((67108872 * 64 * 25)) $logfile "--posix.odirect"
	# iosize: 256M + 8
	test_one 268435464 $((268435464 * 16 * 35)) $logfile "--posix.odirect"
}

run_autoio() {
	echo "Benchmark autoIO I/O performance for a single stream I/O"
	logfile="$logdir/ior.singlestream.autoIO.log"
	# Enable autoIO on the client
	$LCTL set_param llite.*.bio_as_dio=1
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

# runs base bio only as an example
run_base_bio
# run_base_dio
# run_base_udio
# run_autoio