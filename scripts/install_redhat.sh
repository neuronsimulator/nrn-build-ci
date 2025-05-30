#!/bin/bash
set -eu
# Use DNF if available (not CentOS7), otherwise YUM
CMD=$(command -v dnf || command -v yum)

${CMD} update -y
${CMD} install -y procps bison boost-devel cmake diffutils dnf findutils \
  flex gcc gcc-c++ git ${mpi_lib:-openmpi-devel} libXcomposite-devel \
  libXext-devel make openssl-devel python3-devel readline-devel \
  ncurses-devel ninja-build sudo which wget unzip ccache
