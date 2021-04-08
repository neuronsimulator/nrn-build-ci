#!/bin/bash
# ---
# --- Begin GitHub-Actions-specific code ---
# ---
# Avoid apt-get install hanging asking for user input to configure packages
export DEBIAN_FRONTEND=noninteractive
# ---
# --- End GitHub-Actions-specific code ---
# ---
apt-get update
apt-get install -y bison cmake flex git libncurses-dev libmpich-dev \
  libx11-dev libxcomposite-dev ninja-build mpich python3-numpy \
  python3-pip python3-setuptools python3-venv python3-wheel sudo
