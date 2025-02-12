#!/bin/bash
# Enable the (official) PowerTools repository. This provides Ninja.
dnf install -y dnf-plugins-core "python${MIN_PYTHON_MAJOR_VERSION}${MIN_PYTHON_MINOR_VERSION}-devel" gcc-toolset-9-gcc gcc-toolset-9-gcc-c++
NRN_PYTHON="$(command -v "python${MIN_PYTHON_MAJOR_VERSION}.${MIN_PYTHON_MINOR_VERSION}")"
export NRN_PYTHON
echo "NRN_PYTHON=${NRN_PYTHON}" >> $GITHUB_ENV
dnf config-manager --set-enabled powertools
