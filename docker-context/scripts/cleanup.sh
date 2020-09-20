#!/bin/bash

# STRICT MODE AND ERROR IMPROVEMENTS (must be at top of script)
# https://olivergondza.github.io/2019/10/01/bash-strict-mode.html
set -euo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'
### END


# CLEAN UP
apt-get clean || true
apt-get autoclean || true
apt-get autoremove || true
rm -rf /home/temp || true
### END