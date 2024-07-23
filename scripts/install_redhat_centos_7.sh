#!/bin/bash
# Use MPICH instead of OpenMPI on CentOS7, see #51.
# This variable will be read by install_redhat.sh
mpi_lib=mpich-devel

# CentOS 7 is EOL as of 2024-06-30, so we need to use the vault
sed -i 's|mirrorlist.centos.org|vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo
sed -i 's|#baseurl=http://vault.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo
yum clean all
yum makecache

# actually install the packages
# EPEL is needed to get CMake 3 in CentOS7
# SCL is needed to get a modern toolchain in CentOS7
yum install -y epel-release centos-release-scl centos-release-scl-rh

# Install a newer toolchain for CentOS7
yum install -y cmake3 ${SOFTWARE_COLLECTIONS_centos_7} rh-python38-python-devel

# Make sure `cmake` and `ctest` see the 3.x versions, instead of the ancient
# CMake 2 included in CentOS7
alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
  --slave /usr/local/bin/ctest ctest /usr/bin/ctest3 \
  --slave /usr/local/bin/cpack cpack /usr/bin/cpack3 \
  --slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3

# Install a newer version of Flex; this logic is copied from that in the
# Dockerfile that is used to build the NEURON Python wheels.
curl -L -o flex-2.6.4-9.el9.src.rpm http://mirror.stream.centos.org/9-stream/AppStream/source/tree/Packages/flex-2.6.4-9.el9.src.rpm
yum-builddep -y flex-2.6.4-9.el9.src.rpm
yum install -y rpm-build
rpmbuild --rebuild flex-2.6.4-9.el9.src.rpm
ls -R ${HOME}/rpmbuild
yum install -y ${HOME}/rpmbuild/RPMS/x86_64/*.rpm
flex --version
