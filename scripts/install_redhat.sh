#!/bin/bash
# Use DNF if available (not CentOS7), otherwise YUM
CMD=$(command -v dnf || command -v yum)
${CMD} update -y
${CMD} install -y bison boost-devel cmake diffutils dnf findutils \
  flex gcc gcc-c++ git openmpi-devel libXcomposite-devel \
  libXext-devel make openssl-devel python3-devel readline-devel \
  ncurses-devel ninja-build sudo which wget unzip
