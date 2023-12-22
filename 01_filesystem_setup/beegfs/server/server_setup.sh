#!/bin/sh

# Setup beeGFS servers
sh server_install.sh
sh server_reformat.sh
sh server_config.sh
sh server_start.sh
