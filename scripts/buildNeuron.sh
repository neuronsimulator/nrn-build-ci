#!/bin/bash
# Set up the runtime environment by sourcing the environmentXXX.sh scripts.
# For a local installation you might have put the content of those scripts
# directly into your ~/.bashrc or ~/.zshrc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT_DIR}/environment.sh"

# Choose which Python version to use. If an installation script set NRN_PYTHON,
# use that.
export PYTHON=${NRN_PYTHON:-$(command -v python3)}

# Set up a virtual environment. On some distros (Ubuntu 18.04 + Python 3.7) we
# only get venv from the system packages, not pip.
${PYTHON} -m venv nrn_venv
. nrn_venv/bin/activate

# Make sure we have a modern pip, old ones may not handle dependency versions
# correctly
pip install --upgrade pip

# Use the virtual environment python instead of the system one it redirects to
export PYTHON=$(command -v python)

# nrniv -python does not copy properly with virtualenvs
export PYTHONPATH=$(${PYTHON} -c 'import site; print(":".join(site.getsitepackages()))')

# Install extra dependencies for NEURON into the virtual environment.
pip install --upgrade -r nrn_requirements.txt
