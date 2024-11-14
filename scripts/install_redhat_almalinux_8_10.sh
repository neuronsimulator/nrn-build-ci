#!/bin/bash
set -eu
# Enable the (official) PowerTools repository. This provides Ninja.
dnf install -y dnf-plugins-core "python3${MIN_MINOR_PYTHON_VERSION}-devel" gcc-toolset-9-gcc gcc-toolset-9-gcc-c++
NRN_PYTHON="$(command -v "python3.${MIN_MINOR_PYTHON_VERSION}")"
export NRN_PYTHON
echo "NRN_PYTHON=${NRN_PYTHON}" >> $GITHUB_ENV
dnf config-manager --set-enabled powertools
