#!/bin/sh
# Multiple I/O stream throughput

LCTL=$(which lctl)
logdir="output/multiplestream/lustre"

run_bio_one() {
	local bs=$1
	local logf=$2

	/usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -np 16 /work/tools/bin/ior -t $bs -b 80g -k -E -e -w -F -o /exafs/iordir/test >> $logf
	
	/usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -np 16 /work/tools/bin/ior -t $bs -b 80g -k -E -e -w -F -o /exafs/iordir/test >> logf
}

run_dio_one() {
	local bs=$1
	local logf=$2

	/usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -np 16 /work/tools/bin/ior -t $bs -b 80g -k -E -e -w -F "--posix.odirect" -o /exafs/iordir/test >> $logf
	
	/usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -np 16 /work/tools/bin/ior -t $bs -b 80g -k -E -e -w -F "--posix.odirect" -o /exafs/iordir/test >> logf
}

autoio_stats() {
	local logf=$1

	local largeio
	local contend
	local pressure
	local overcache
	local asbio_smallio
	local asbio_other

	largeio=$($LCTL get_param llite.*.stats | awk '/asdio_largeio/ { sum += $3} END { printf("%0.0f\n", sum) }')
	contend=$($LCTL get_param llite.*.stats | awk '/asdio_contend/ { sum += $3} END { printf("%0.0f\n", sum) }')
	pressure=$($LCTL get_param llite.*.stats | awk '/asdio_pressure/ { sum += $3} END { printf("%0.0f\n", sum) }')
	overcache=$($LCTL get_param llite.*.stats | awk '/asdio_overcache/ { sum += $3} END { printf("%0.0f\n", sum) }')
	asbio_smallio=$($LCTL get_param llite.*.stats | awk '/asbio_smallio/ { sum += $3} END { printf("%0.0f\n", sum) }')
	asbio_other=$($LCTL get_param llite.*.stats | awk '/asbio_other/ { sum += $3} END { printf("%0.0f\n", sum) }')

	echo "largerio: $largeio" >> $logf
	echo "contend: $contendio" >> $logf
	echo "pressure: $pressure" >> $logf
	echo "overcache: $overcache" >> $logf
	echo "asbio_smallio: $asbio_smallio" >> $logf
	echo "asbio_other: $asbio_other" >> $logf
}

run_autoio_one() {
	local bs=$1
	local logf=$2

	$LCTL set_param llite.*.stats=clear
	echo "MultipleStream Write: bs=$bs" >> $logf
	/usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -np 16 /work/tools/bin/ior -t $bs -b 80g -k -E -e -w -F -o /exafs/iordir/test >> $logf
	autoio_stats $logf

	$LCTL set_param llite.*.stats=clear
	echo "MultipleStream Read: bs=$bs" >> $logf
	/usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun --allow-run-as-root -np 16 /work/tools/bin/ior -t $bs -b 80g -k -E -e -w -F -o /exafs/iordir/test >> logf
	autoio_stats $logf
}

mkdir -p $logdir

# Benchmark for buffered I/O (multiple stream)
logfile="$logdir/multiplestream.BIO.log"
for iosz in "256K 512K 1M 2M"; do
	run_bio_one $iosz $logfile
done

# Benchmark for direct I/O (multiple stream)
logfile="$logdir/multiplestream.DIO.log"
for iosz in "256K 512K 1M 2M"; do
	run_dio_one $iosz $logfile
done

# Enable autoIO on the client
$LCTL set_param llite.*.bio_as_dio=1
logfile="$logdir/multipestream.AutoIO.log"
for iosz in "256K 512K 1M 2M"; do
	run_autoio_one $iosz $logfile
done


