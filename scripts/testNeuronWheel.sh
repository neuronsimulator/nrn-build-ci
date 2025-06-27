#!/bin/bash
set -x
# Set up the runtime environment by sourcing the environmentXXX.sh scripts.
# For a local installation you might have put the content of those scripts
# directly into your ~/.bashrc or ~/.zshrc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT_DIR}/environment.sh"
DROP_DIR="${SCRIPT_DIR}/../drop"
USE_VENV="true"
export PYTHON=${NRN_PYTHON:-$(command -v python3)}
# If artifact is there, install the wheel
if [[ -d "${DROP_DIR}" ]]; then
  echo "Using wheel from ${DROP_DIR}"
  ${PYTHON} -m venv wheel_test_venv
  . wheel_test_venv/bin/activate
  export PYTHON=$(command -v python)
  # install wheel from artifact
  pip install --no-index --find-links ${DROP_DIR} neuron-nightly
  # get version of NEURON to avoid downloading something else in the venv for test_wheels.sh
  NRN_PACKAGE="neuron-nightly==$(pip show neuron-nightly | grep Version | cut -d ' ' -f2 )"
  USE_VENV="false"
fi
# Run NEURON's wheel testing script
echo "Testing NEURON wheel: ${NRN_PACKAGE} (venv=${USE_VENV})"
./packaging/python/test_wheels.sh ${PYTHON} ${NRN_PACKAGE} ${USE_VENV}
