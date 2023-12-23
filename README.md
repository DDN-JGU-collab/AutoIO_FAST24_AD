# FAST '24: "Combining Buffered I/O and Direct I/O in Distributed File Systems" Artifacts Description
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10425916.svg)](https://doi.org/10.5281/zenodo.10425916)


This repository contains the instructions to setup a similar environment as was used in the paper "*Combining Buffered I/O and Direct I/O in Distributed File Systems*" from the USENIX FAST 24 submission. In addition, these artifacts provide a detailed description of the configurations of the experiments in the paper.

Please note that due to the complexity of fully configuring and testing a Lustre installation, these artifacts are not *functional* (as in all scripts run automatically). However, this repository makes the artifacts description *available* for reference, making it possible to run similar experiments in similar configurations as provided in the paper.

These artifacts contain the following contents:

## Table of contents

* Directory structure
* Prerequisites
* Installing file systems 
    - Lustre with autoIO
    - BeeGFS
    - OrangeFS
* Used benchmarks and applications

## Directory structure

The following directory structure covers the setup and configurations of all used file systems and all used experiments from the paper.

The `01_filesystem_setup` directory includes reference instructions how to build, install, and deploy Lustre with the Lustre modifications presented in the paper. Moreover, this directory includes reference instructions for setting up BeeGFS and OrangeFS.

The `02_motivation` directory includes reference instructions for the experiment from Figures 1 and 2.

The `03_single_io_stream` directory includes reference instructions for the experiments from Figure 4, 5, and 6.

The `04_multiple_io_stream` directory includes reference instructions for the experiments from Figure 7.

The `05_io500` directory includes reference instructions for the experiments from Figures 8, 9, and 10.

The `06_mpifileutils` directory includes reference instructions for the experiments from Figures 11, 12, and 13.

The `07_vpicio` directory includes reference instructions for the experiments from Figure 14.

The `08_nek5000` directory includes reference instructions for the experiments from Figures 15 and 16.

## Lustre modifications

The following presents the individual artifacts that include all code modifications to Lustre in the context of this paper:

**Artifact 1:**\
Persistent ID (DOI, GitHub URL, etc.): https://jira.whamcloud.com/browse/LU-13805 \
Artifact name: I/O path: Unaligned direct I/O \
Citation of artifact (if known): https://jira.whamcloud.com/browse/LU-13805

**Artifact 2**:\
Persistent ID (DOI, GitHub URL, etc.): https://jira.whamcloud.com/browse/LU-16355 \
Artifact name:  batch dirty buffered write of small files \
Citation of artifact (if known): https://jira.whamcloud.com/browse/LU-16355

**Artifact 3**:\
Persistent ID (DOI, GitHub URL, etc.): https://jira.whamcloud.com/browse/LU-12550 \
Artifact name:  ldlm: contention detection \
Citation of artifact (if known): https://review.whamcloud.com/35287

**Artifact 4**:\
Persistent ID (DOI, GitHub URL, etc.): https://jira.whamcloud.com/browse/LU-16964 \
Artifact name: I/O path: auto switch from BIO to DIO \
Citation of artifact (if known): https://review.whamcloud.com/51679

**Artifact 5**: \
Persistent ID (DOI, GitHub URL, etc.): https://jira.whamcloud.com/browse/LU-12916 \
Artifact name:  osd: use writeback for small writes in ldiskfs \
Citation of artifact (if known): https://review.whamcloud.com/50687

**Artifact 6**:\
Persistent ID (DOI, GitHub URL, etc.): https://jira.whamcloud.com/browse/LU-12916 \
Artifact name:  osd-ldiskfs: check and submit good full write \
Citation of artifact (if known): https://review.whamcloud.com/50940

**Artifact 7**: \
Persistent ID (DOI, GitHub URL, etc.): https://jira.whamcloud.com/browse/LU-12916 \
Artifact name:  osd-ldiskfs: add delayed allocation support \
Citation of artifact (if known): https://review.whamcloud.com/51033

**Artifact 8**: \
Persistent ID (DOI, GitHub URL, etc.): https://jira.whamcloud.com/browse/LU-12916 \
Artifact name:  osd-ldiskfs: detect good extent via extent tree \
Citation of artifact (if known): https://review.whamcloud.com/51063

**Artifact 9**: \
Persistent ID (DOI, GitHub URL, etc.): https://wiki.lustre.org/Compiling_Lustre \
Artifact name:  Compiling Lustre 

**Artifact 10**: \
Persistent ID (DOI, GitHub URL, etc.): https://doc.lustre.org/lustre_manual.xhtml \
Artifact name: Lustre Manual

## Prerequisites
The experiments in the paper were run on a Lustre cluster that consisted of 1 Metadata Target (MDT), 8 Object Storage Targets (OSTs), and 32 client nodes. The servers have used a DDN AI400X Appliance (20x SAMSUNG 3.84~TiB NVMe, 4x IB-HDR100) as backend, running Lustre 2.16. All clients included one Intel Gold 5218 processor, 96 GiB DDR4 RAM, and ran CentOS 8.4 Linux. All nodes were connected using Infiniband IB-HDR100.

When running CentOS 8.4 Linux, the following software packages are required:
```bash
sudo yum install asciidoc audit-libs-devel automake bc binutils-devel \
bison device-mapper-devel elfutils-devel elfutils-libelf-devel expect \
flex gcc gcc-c++ git glib2 glib2-devel hmaccalc keyutils-libs-devel \
krb5-devel ksh libattr-devel libblkid-devel libselinux-devel libtool \
libuuid-devel libyaml-devel lsscsi make ncurses-devel net-snmp-devel \
net-tools newt-devel numactl-devel parted patchutils pciutils-devel \
perl-ExtUtils-Embed pesign python-devel redhat-rpm-config rpm-build \
systemd-devel tcl tcl-devel tk tk-devel wget xmlto yum-utils zlib-devel
```

For running the experiments, MPI and environment variables are required:

```bash
yum install mpich
yum install mpich-devel
export PATH=$PATH:/usr/lib64/mpich/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/mpich/lib
```

We used `clush`` for executing commands in parallel on our cluster and for gathering the corresponding results. More information can be found here: https://clustershell.readthedocs.io/en/latest/tools/clush.html

## Installing file systems

The following includes reference instructions to set up Lustre, BeeGFS, and OrangeFS

### Installing Lustre with autoIO

First, the OFED drivers need to be build and installed according to Artifact 9. Next, the Lustre client and server versions need to be build including the corresponding patch sets:
- Lustre client: Refer to the [Client bash script](01_filesystem_setup/lustre/client.sh)
- Lustre server: Refer to the [Server bash script](01_filesystem_setup/lustre/server.sh)

The shell scripts should be used as a reference to build Lustre and deploy it. For further information on configuring Lustre, refer to Artifact 10. Chapter 10 of the Lustre manual presents a complete installation for a simple Lustre file system.

### Installing BeeGFS

We used BeeGFS in version 7.4.0. The BeeGFS server and client instruction references are available at https://doc.beegfs.io/latest/quick_start_guide/quick_start_guide.html . In addition, we provide our used scripts to setup and re-config BeeGFS:
- BeeGFS client: Refer to the [Client script directory](01_filesystem_setup/beegfs/client/)
- BeeGFS server: Refer to the [Server script directory](01_filesystem_setup/beegfs/server/)

### Installing OrangeFS

We used OrangeFS in version 2.10.0 on CentOS 8.7. The OrangeFS server and client instruction references are available at https://docs.orangefs.com/quickstart/quickstart-package/. In addition, we provide our used scripts to setup and re-config OrangeFS:
- OrangeFS client: Refer to the [Client script directory](01_filesystem_setup/orangefs/client/)
- OrangeFS server: Refer to the [Server script directory](01_filesystem_setup/orangefs/server/)

## Used benchmarks and applications

We used the following benchmark tools and applications. Their individual installation instructions are found on their corresponding websites and not included in this artifact description:
- IOR, mdtest: https://github.com/hpc/ior
- IO500: https://github.com/IO500/io500
- DCP: https://github.com/hpc/mpifileutils
- perf: https://man7.org/linux/man-pages/man1/perf.1.html
- VPIC-IO: https://doi.org/10.11578/dc.20181218.4 via h5bench: https://github.com/hpc-io/h5bench running VPIC-IO's I/O kernel. Build instructions: https://h5bench.readthedocs.io/en/latest/buildinstructions.html
- Nek5000: https://doi.org/10.11578/dc.20210416.29 with its turbPipe workload
