#!/bin/bash
set -eu
# Enable the (official) CRB repository. This provides Ninja.
dnf install -y dnf-plugins-core
dnf config-manager --set-enabled crb
# CentOS Stream 9 default python3 is 3.9; NEURON needs >= 3.10.
# AppStream provides python3.11.
dnf install -y python3.11 python3.11-devel
NRN_PYTHON="$(command -v python3.11)"
export NRN_PYTHON
echo "NRN_PYTHON=${NRN_PYTHON}" >> $GITHUB_ENV
