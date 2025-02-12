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
apt-get install -y software-properties-common bison cmake flex git libncurses-dev libmpich-dev libssl-dev \
  libx11-dev libxcomposite-dev ninja-build mpich libreadline-dev sudo wget unzip curl
if [[ "${DO_NOT_INSTALL_BOOST}" != "true" ]]; then
  apt-get install -y libboost-all-dev
fi
if [[ -z "${NRN_PYTHON}" ]]; then
  add-apt-repository -y ppa:deadsnakes/ppa
  apt-get install -y "python${MIN_PYTHON_MAJOR_VERSION}.${MIN_PYTHON_MINOR_VERSION}-dev" "python${MIN_PYTHON_MAJOR_VERSION}.${MIN_PYTHON_MINOR_VERSION}-venv"
  NRN_PYTHON="$(command -v "python${MIN_PYTHON_MAJOR_VERSION}.${MIN_PYTHON_MINOR_VERSION}")"
  export NRN_PYTHON
  echo "NRN_PYTHON=${NRN_PYTHON}" >> $GITHUB_ENV
fi
