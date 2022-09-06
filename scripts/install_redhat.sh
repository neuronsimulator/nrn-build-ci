#!/bin/bash
# Use DNF if available (not CentOS7), otherwise YUM
CMD=$(command -v dnf || command -v yum)

# Use mpich on centos7 otherwise use openmpi
# See neuronsimulator/nrn-build-ci/pull/51
mpi_lib=$(if cat /etc/*release | grep -q CentOS-7; then echo "mpich-devel"; else echo "openmpi-devel"; fi)

${CMD} update -y
${CMD} install -y bison boost-devel cmake diffutils dnf findutils \
  flex gcc gcc-c++ git ${mpi_lib} libXcomposite-devel \
  libXext-devel make openssl-devel python3-devel readline-devel \
  ncurses-devel ninja-build sudo which wget unzip
