#!/bin/bash
# Set up the runtime environment by sourcing the environmentXXX.sh scripts.
# For a local installation you might have put the content of those scripts
# directly into your ~/.bashrc or ~/.zshrc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT_DIR}/environment.sh"

# Get artifact URL and unzip
ARTIFACT_DROP_URL="$1"

if [[ -d drop ]]
then
    rm -rf drop
fi

if [[ "${ARTIFACT_DROP_URL}" =~ https://github.com/neuronsimulator.* ]]
then
    ARTIFACT_ID=$(echo "${ARTIFACT_DROP_URL}" | grep --color=never -oE '[0-9]+$')
    echo "Extracted Artifact ID: ${ARTIFACT_ID}"
    curl -L -sfS \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${NRN_MODELDB_CI_TOKEN}" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/neuronsimulator/nrn/actions/artifacts/${ARTIFACT_ID}/zip" -o drop.zip
    unzip -d drop drop.zip
else
    wget --tries=4 -LO drop.zip "${ARTIFACT_DROP_URL}"
    unzip drop.zip
fi
