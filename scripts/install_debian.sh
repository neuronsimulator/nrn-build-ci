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
  libx11-dev libxcomposite-dev ninja-build mpich libreadline-dev sudo wget \
  unzip libssl-dev # for tqperf integration test
if [[ -z "${NRN_PYTHON}" ]]; then
  apt-get install -y python3-dev python3-venv
  export NRN_PYTHON=$(command -v python3)
  echo "NRN_PYTHON=${NRN_PYTHON}" >> $GITHUB_ENV
fi
