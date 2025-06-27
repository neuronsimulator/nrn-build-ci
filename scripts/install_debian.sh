#!/bin/bash
set -eu
# ---
# --- Begin GitHub-Actions-specific code ---
# ---
# Avoid apt-get install hanging asking for user input to configure packages
export DEBIAN_FRONTEND=noninteractive
# ---
# --- End GitHub-Actions-specific code ---
# ---
apt-get update
apt-get install -y bison cmake flex git libncurses-dev libmpich-dev libssl-dev \
  libx11-dev libxcomposite-dev ninja-build mpich libreadline-dev sudo wget unzip curl
if [[ "${DO_NOT_INSTALL_BOOST:-false}" != "true" ]]; then
  apt-get install -y libboost-all-dev
fi
if [[ -z "${NRN_PYTHON:-}" ]]; then
  apt-get install -y python3-dev python3-venv

  python_minor_version="$(python3 -c 'import sys;print(sys.version_info.minor)')"
  if [[ "${python_minor_version}" -lt "${MIN_MINOR_PYTHON_VERSION}" ]]
  then
      # install min supported Python version from external repo
      apt-get install -y software-properties-common
      add-apt-repository -y ppa:deadsnakes/ppa
      apt-get install -y "python3.${MIN_MINOR_PYTHON_VERSION}-dev" "python3.${MIN_MINOR_PYTHON_VERSION}-venv"
      NRN_PYTHON="$(command -v "python3.${MIN_MINOR_PYTHON_VERSION}")"
      export NRN_PYTHON
  elif [[ "${python_minor_version}" -gt "${MAX_MINOR_PYTHON_VERSION}" ]]
  then
      # we do not want to downgrade the default version (this is _very_ unlikely to happen on Ubuntu/Debian though)
      printf "Distribution %s comes with a version of Python that is too new (%s) for NEURON\n" "$(cat /etc/lsb-release)" "3.${python_minor_version}"
      printf "Please downgrade it to at most Python %s\n" "3.${MAX_MINOR_PYTHON_VERSION}"
      exit 1
  else
      NRN_PYTHON="$(command -v python3)"
      export NRN_PYTHON
  fi
  # export to github env
  echo "NRN_PYTHON=${NRN_PYTHON}" >> $GITHUB_ENV
fi
