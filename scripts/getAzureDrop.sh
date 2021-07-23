#!/bin/bash
# Set up the runtime environment by sourcing the environmentXXX.sh scripts.
# For a local installation you might have put the content of those scripts
# directly into your ~/.bashrc or ~/.zshrc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT_DIR}/environment.sh"
# Get Azure drop and unzip
AZURE_DROP_URL="$1"
rm -rf drop
wget --tries=4 -LO drop.zip ${AZURE_DROP_URL}
unzip drop.zip
