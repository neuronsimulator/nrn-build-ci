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
# If Azure drop is there, install the wheel
if [[ -d "${DROP_DIR}" ]]; then
  ${PYTHON} -m venv wheel_test_venv
  . wheel_test_venv/bin/activate
  export PYTHON=$(command -v python)
  # install wheel from drop
  pip install --find-links ${DROP_DIR} neuron-nightly
  # get Azure version to avoid downloading something else in the venv for test_wheels.sh
  NRN_PACKAGE="neuron-nightly==$(pip show neuron-nightly | grep Version | cut -d ' ' -f2 )"
  USE_VENV="false"
elif [[ -n "${NEURON_BRANCH_OR_TAG}" ]]; then
  # Assume it's a tag that matches the PyPI release version
  NRN_PACKAGE="neuron==${NEURON_BRANCH_OR_TAG}"
else
  NRN_PACKAGE="neuron-nightly"
fi
# Run NEURON's wheel testing script
echo "Testing NEURON wheel: ${NRN_PACKAGE} (venv=${USE_VENV})"
./packaging/python/test_wheels.sh ${PYTHON} ${NRN_PACKAGE} ${USE_VENV}
