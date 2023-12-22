#!/bin/sh

# Restart the orangeFS servers with a given I/O mode.
# TroveMethod alt-aio
# TroveMethod directio

mode=$1
conf="/work/qian/orangefs/server/opt/etc/orangefs-server.conf"

sh stop.sh
sed -i "/TroveMethod /s/ .*$/\ $mode/" $conf
sh start.sh
