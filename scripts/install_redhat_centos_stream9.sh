#!/bin/bash
set -eu
# Enable the (official) CRB repository. This provides Ninja.
dnf install -y dnf-plugins-core
dnf config-manager --set-enabled crb
