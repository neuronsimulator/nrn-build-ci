#!/bin/bash
# Enable the (official) PowerTools repository. This provides Ninja.
dnf install -y dnf-plugins-core "python3${PYTHON_MIN_VERSION}-devel" gcc-toolset-9-gcc gcc-toolset-9-gcc-c++
NRN_PYTHON="$(command -v "python3.${PYTHON_MIN_VERSION}")"
export NRN_PYTHON
echo "NRN_PYTHON=${NRN_PYTHON}" >> $GITHUB_ENV
dnf config-manager --set-enabled powertools
