#!/bin/bash
# Set up the runtime environment by sourcing the environmentXXX.sh scripts in
# the same directory as this script.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ENV_SCRIPT_CONTAINER="${SCRIPT_DIR}/environment_${OS_FLAVOUR}_${OS_CONTAINER}.sh"
if [ -f "${ENV_SCRIPT_CONTAINER}" ]; then source "${ENV_SCRIPT_CONTAINER}"; fi
ENV_SCRIPT_FLAVOUR="${SCRIPT_DIR}/environment_${OS_FLAVOUR}.sh"
if [ -f "${ENV_SCRIPT_FLAVOUR}" ]; then source "${ENV_SCRIPT_FLAVOUR}"; fi

# Generic setup: make sure the user install directory used by pip is found
PYTHON_USER_BASE=$(python3 -c "import site; print(site.USER_BASE)")
export PATH=${PYTHON_USER_BASE}/bin:${PATH}
export JUPYTER_PATH=${PYTHON_USER_BASE}/share/jupyter
