#!/bin/bash
# Set up the runtime environment by sourcing the environmentXXX.sh scripts.
# For a local installation you might have put the content of those scripts
# directly into your ~/.bashrc or ~/.zshrc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DROP_DIR="${SCRIPT_DIR}/../drop"
USE_VENV="true"
source "${SCRIPT_DIR}/environment.sh"
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
  NRN_NIGHTLY_VER="==$( python3 -m pip show neuron-nightly | grep Version | cut -d ' ' -f2 )"
  USE_VENV="false"
fi
# Run NEURON's wheel testing script
./packaging/python/test_wheels.sh python3 neuron-nightly${NRN_NIGHTLY_VER} $USE_VENV
