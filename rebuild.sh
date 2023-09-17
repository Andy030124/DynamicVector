#!/usr/bin/env bash

## Bash Include files
source $(dirname $0)/utils.sh

clear

postMessage "[0]" "Deleting all obj files & executable files..."
make cleanall
drawOK

postMessage "[1]" "Making Files..."
make -j
drawOK
