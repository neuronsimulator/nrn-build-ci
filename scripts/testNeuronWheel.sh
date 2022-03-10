#!/bin/bash
set -x
# Set up the runtime environment by sourcing the environmentXXX.sh scripts.
# For a local installation you might have put the content of those scripts
# directly into your ~/.bashrc or ~/.zshrc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT_DIR}/environment.sh"
DROP_DIR="${SCRIPT_DIR}/../drop"
USE_VENV="true"
# If Azure drop is there, install the wheel
if [[ -d "${DROP_DIR}" ]]; then
  # upgrade pip for 3.6 (for manylinux2014 support)
  python_ver=$( python3 -c "import sys; print('%d%d' % tuple(sys.version_info)[:2])" )
  if [[ "$python_ver" == "36" ]]; then
    python3 -m pip install --user --upgrade pip
  fi

  # install wheel from drop
  python3 -m pip install --user --find-links ${DROP_DIR} neuron-nightly
  # get Azure version to avoid downloading something else in the venv for test_wheels.sh
  NRN_PACKAGE="neuron-nightly==$( python3 -m pip show neuron-nightly | grep Version | cut -d ' ' -f2 )"
  USE_VENV="false"
elif [[ -n "${NEURON_BRANCH_OR_TAG}" ]]; then
  # Assume it's a tag that matches the PyPI release version
  NRN_PACKAGE="neuron==${NEURON_BRANCH_OR_TAG}"
else
  NRN_PACKAGE="neuron-nightly"
fi
# Run NEURON's wheel testing script
echo "Testing NEURON wheel: ${NRN_PACKAGE} (venv=${USE_VENV})"
./packaging/python/test_wheels.sh python3 ${NRN_PACKAGE} ${USE_VENV}
