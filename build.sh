#!/usr/bin/env bash

## Bash Include files
source $(dirname $0)/utils.sh

clear

postMessage "[0]" "Making Files & Checking Changes..."
make -j
drawOK
