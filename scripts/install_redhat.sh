#!/bin/bash
# Use DNF if available (not CentOS7), otherwise YUM
CMD=$(command -v dnf || command -v yum)

if [[ "${OS_CONTAINER}" == 'fedora_latest' ]]
then
    # on Fedora latest we explicitly pin 3.11 for now
    PYTHON_VERSION="3.11"
else
    # use the default one
    PYTHON_VERSION="3"
fi

${CMD} update -y
${CMD} install -y procps bison boost-devel cmake diffutils dnf findutils \
  flex gcc gcc-c++ git ${mpi_lib:-openmpi-devel} libXcomposite-devel \
  libXext-devel make openssl-devel python"${PYTHON_VERSION}"-devel readline-devel \
  ncurses-devel ninja-build sudo which wget unzip
