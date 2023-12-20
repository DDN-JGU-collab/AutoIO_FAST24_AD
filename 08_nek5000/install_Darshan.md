# Install Darshan

```bash
wget https://ftp.mcs.anl.gov/pub/darshan/releases/darshan-3.4.4.tar.gz
tar xf darshan-3.4.4.tar.gz
cd darshan-3.4.4
./prepare.sh
cd darshan-runtime
```

```bash
mkdir build && cd build

../configure --disable-lustre-mod --with-jobid-env=NONE --with-mem-align=8 --enable-mmap-logs --prefix=/home/vef/turbPipe/darshan/install --with-log-path=/home/vef/turbPipe/darshan/logs CC=mpicc

make -j8
make install
```

Create and populate log directory

```bash
mkdir -p /home/vef/turbPipe/darshan/log
/home/vef/turbPipe/darshan/install/bin/darshan-mk-log-dirs.pl
```

Create a darshan config file with some settings containing:

```bash

# number of records for all modules
MAX_RECORDS 256000 POSIX,MPI-IO,STDIO
# max used memory by all darshan modules
MODMEM  2048
# allows per rank information
DISABLE_SHARED_REDUCTION
```

# Run Nek with Darshan

```bash
cd /home/vef/turbPipe/run_lustre
time mpiexec -np 32 --oversubscribe --map-by node --hostfile /home/vef/hostfile_nek_lustre ./nek5000
```

Add LD_PRELOAD and DARSHAN_CONFIG_PATH to mpi

```bash
time mpiexec -np 32 --oversubscribe --map-by node -x LD_PRELOAD=/home/vef/turbPipe/darshan/install/lib/libdarshan.so -x DARSHAN_CONFIG_PATH=/home/vef/turbPipe/darshan/darshan.config --hostfile /home/vef/hostfile_nek_lustre ./nek5000
```

When the run is successful, the Darshan file is in the log directory.