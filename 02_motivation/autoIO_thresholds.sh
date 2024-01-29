#!/bin/sh
tfile="/exafs/s8/test"
dir="/exafs/s8"
LFS=$(which lfs)
LCTL=$(which lctl)
logdir="output/autoIO_threshold"
AUTOIOSTATS="./autoiostats.sh"

mkdir -p $logdir

test_one() {
	local bs=$1
	local sz=$2
	local logf=$3

    # clear statistics
    clush -w ec[01-32] $LCTL set_param llite.*.stats=clear
    # flush caches
	echo 3 > /proc/sys/vm/drop_caches
	clush -w ai400x2-2-vm[1-4] "echo 3 > /proc/sys/vm/drop_caches"
	sleep 1
	echo "========= ior test: bs=$1 ============"
	/work/tools/bin/ior -t $bs -b $sz -k -E -e -w -r -F $direct -o $tfile >> $logf
	# autoIO stats
    sh $AUTOIOSTATS
    rm -rf $dir/*
	sleep 1
}

run_autoio() {
	local small_thresh=$1
	local large_thresh=$2
	local transfer_size=$3

	echo "Small threshold=$small_thresh"
	echo "Large threshold=$large_thresh"
	logfile="$logdir/ior.autoIO.${small_thresh}.${large_thresh}"
	# Enable autoIO on the client
	$LCTL set_param llite.*.bio_as_dio=1
	$LCTL set_param llite.*.switch_dio_threshold=$small_thresh
	$LCTL set_param llite.*.switch_dio_smallio=$large_thresh
    # run test
	test_one $transfer_size "200g" $logfile
}

# small and large I/O thresholds are the same (these test due not require a range between both thresholds)
# buffered I/O cases due to `io_size < small_io_threshold`
# run_autoio <small_threshold> <large_threshold> <io_size>
run_autoio "16K"    "16K"   "4K"
run_autoio "64K"    "64K"   "16K"
run_autoio "256K"   "256K"  "64K"
run_autoio "1M"     "1M"    "256K"
run_autoio "2M"     "2M"    "1M"
run_autoio "4M"     "4M"    "2M"
run_autoio "16M"    "16M"   "4M"
run_autoio "64M"    "64M"   "16M"
run_autoio "256M"   "256M"  "64M"
run_autoio "512M"   "512M"  "256M"

# direct I/O cases due to `io_size >= large_io_threshold`
run_autoio "1K"     "1K"    "4K"
run_autoio "4K"     "4K"    "16K"
run_autoio "16K"    "16K"   "64K"
run_autoio "64K"    "64K"   "256K"
run_autoio "256K"   "256K"  "1M"
run_autoio "1M"     "1M"    "2M"
run_autoio "2M"     "2M"    "4M"
run_autoio "4M"     "4M"    "16M"
run_autoio "16M"    "16M"   "64M"
run_autoio "64M"    "64M"   "256M"