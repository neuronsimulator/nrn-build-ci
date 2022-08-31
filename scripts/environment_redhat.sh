#!/bin/bash
# ---
# --- Begin GitHub-Actions-specific code ---
# ---
# This is working around GitHub Actions running commands in non-login shells
# that would otherwise not have the `module` command available.
source /etc/profile.d/modules.sh
# ---
# --- End GitHub-Actions-specific code ---
# ---
# Assume we only installed one version; otherwise you would have to specify an
# implementation/version of MPI.
module load mpi

# Get the CENTOS VERSION for specific enviroment setup
CENTOS_VERSION=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))
echo "CENTOS_VERSION: ${CENTOS_VERSION}"

# CENTOS 7
if [[ $CENTOS_VERSION == 7* ]]; then
    # Ensure that the newer CMake version that was installed on CentOS7 is
    # preferred over the original system version.
    export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
# CENTOS 8    
elif [[ $CENTOS_VERSION == 8* ]]; then
    # Enable GCC 9
    source /opt/rh/gcc-toolset-9/enable
fi

