#!/bin/sh
# The summary of DIO statistics on all clients for Table 4
# larger I/O
echo "largeio"
clush -w ec[01-32] lctl get_param llite.*.stats | awk '/asdio_largeio/ { sum += $3} END { printf("%0.0f\n", sum) }'
echo "contend"
clush -w ec[01-32] lctl get_param llite.*.stats | awk '/asdio_contend/ { sum += $3} END { printf("%0.0f\n", sum) }'
echo "pressure"
clush -w ec[01-32] lctl get_param llite.*.stats | awk '/asdio_pressure/ { sum += $3} END { printf("%0.0f\n", sum) }'
echo "overcache"
clush -w ec[01-32] lctl get_param llite.*.stats | awk '/asdio_overcache/ { sum += $3} END { printf("%0.0f\n", sum) }'
# small I/O
echo "asbio_smallio"
clush -w ec[01-32] lctl get_param llite.*.stats | awk '/asbio_smallio/ { sum += $3} END { printf("%0.0f\n", sum) }'
# default BIO
echo "asbio_other"
clush -w ec[01-32] lctl get_param llite.*.stats | awk '/asbio_other/ { sum += $3} END { printf("%0.0f\n", sum) }'
