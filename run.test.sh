#!/usr/bin/env bash

## Bash Include files
source $(dirname $0)/utils.sh

clear

postMessage "[0]" "Executing in Normal Mode..."
make test-e2e
drawOK
