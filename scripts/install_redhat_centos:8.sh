#!/bin/bash
# Enable the (official) PowerTools repository. This provides Ninja.
dnf install -y dnf-plugins-core
dnf config-manager --set-enabled powertools
