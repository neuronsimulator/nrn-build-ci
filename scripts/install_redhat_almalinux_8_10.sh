#!/bin/bash
set -eu
# Enable the (official) PowerTools repository. This provides Ninja.
dnf install -y dnf-plugins-core epel-release
dnf config-manager --set-enabled powertools
# AlmaLinux 8 AppStream modules only go up to Python 3.9; NEURON needs >= 3.10.
# EPEL provides python3.11 (package name uses a dot: python3.11-devel).
dnf install -y python3.11 python3.11-devel gcc-toolset-9-gcc gcc-toolset-9-gcc-c++
NRN_PYTHON="$(command -v python3.11)"
export NRN_PYTHON
echo "NRN_PYTHON=${NRN_PYTHON}" >> $GITHUB_ENV
