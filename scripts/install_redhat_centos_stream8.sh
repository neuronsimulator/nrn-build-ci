#!/bin/bash
# Enable the (official) PowerTools repository. This provides Ninja.
dnf install -y dnf-plugins-core python38-devel
export NRN_PYTHON=$(command -v python3.8)
echo "NRN_PYTHON=${NRN_PYTHON}" >> $GITHUB_ENV
dnf config-manager --set-enabled powertools
