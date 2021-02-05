#!/bin/bash
# Use DNF if available (not CentOS7), otherwise YUM
CMD=$(command -v dnf || command -v yum)
${CMD} install -y bison cmake dnf flex gcc gcc-c++ git \
  openmpi-devel libXcomposite-devel libXext-devel make ncurses-devel \
  python3-devel python3-pip python3-wheel sudo which
