#!/bin/sh

# I/O time breakdown for buffered I/O writes for Figure 2

run_io_breakdown_ext4 () {
    # local ldiskfs (ext4) I/O time trace and performance
    # buffered I/O
    perf record -a -g /work/tools/bin/ior -t 16m -b 2560g -k -E -e -w -o /mnt/ldiskfs/ior/iorfile
    # direct I/O
    perf record -a -g /work/tools/bin/ior -t 16m -b 2560g -k -E -e -w --posix.odirect -o /mnt/ldiskfs/ior/iorfile
}

run_io_breakdown_beegfs () {
    # [tuneFileCacheType]
    # Sets the file read/write cache type.
    # Values: "none" (disable client caching), "buffered" (use a pool of small
    #    static buffers for write-back and read-ahead), "native" (use the kernel
    #    pagecache), "paged" (experimental, deprecated).
    # Note: The cache protocols are currently non-coherent (but caches are
    #    automatically flushed when a file is closed).
    # Note: When client and servers are running on the same machine, "paged" mode
    #    contains the typical potential for memory allocation deadlocks (also known
    #    from local NFS server mounts). So do not use "paged" mode for clients that
    #    run on a metadata or storage server machine.

    # beeGFS set in config in: /etc/beegfs/beegfs-client.conf
    # - tuneFileCacheType=native
    # - tuneFileCacheBufSize=16777216 # 16MiB (512KiB by default)
    # buffered I/O
    perf record -a -g /work/tools/bin/ior -t 16m -b 2560g -k -E -e -w -o /mnt/beegfs/s8/iorfile
    # direct I/O
    perf record -a -g /work/tools/bin/ior -t 16m -b 2560g -k -E -e -w --posix.odirect -o /mnt/beegfs/s8/iorfile
}

run_io_breakdown_lustre() {
    # Lustre:
    # buffered I/O
    perf record -a -g /work/tools/bin/ior -t 16m -b 2560g -k -E -e -w -o /exafs/s8/iorfile
    # direct I/O
    perf record -a -g /work/tools/bin/ior -t 16m -b 2560g -k -E -e -w --posix.odirect -o /exafs/s8/iorfile
}

run_io_breakdown_ext4
run_io_breakdown_beegfs
run_io_breakdown_lustre