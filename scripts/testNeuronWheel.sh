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
  # due to https://github.com/pypa/pip/issues/12110 we cannot rely on `--find-links`
  # so we use a workaround
  for wheel in "${DROP_DIR}"/*.whl
  do
    if ! pip install "${wheel}"
    then
      echo "Unable to install ${wheel} (incompatible platform?), trying another one"
    else
      echo "Successfully installed ${wheel}"
      NRN_PACKAGE="${wheel}"
      break
    fi
  done
  USE_VENV="false"
fi
# Run NEURON's wheel testing script
echo "Testing NEURON wheel: ${NRN_PACKAGE} (venv=${USE_VENV})"
./packaging/python/test_wheels.sh ${PYTHON} ${NRN_PACKAGE} ${USE_VENV}
