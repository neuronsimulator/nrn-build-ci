#!/bin/bash
# Use DNF if available (not CentOS7), otherwise YUM
CMD=$(command -v dnf || command -v yum)
${CMD} update -y
${CMD} install -y bison cmake diffutils dnf flex gcc gcc-c++ git \
  openmpi-devel libXcomposite-devel libXext-devel make readline-devel ncurses-devel \
  ninja-build python3-devel python3-pip python3-wheel sudo which wget unzip \
  findutils openssl-devel  # for tqperf integration test
