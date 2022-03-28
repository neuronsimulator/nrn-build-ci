#!/bin/bash
# Enable Kitware repository to pick up a modern version of CMake
# Instructions adapted from https://apt.kitware.com/
apt-get update
apt-get install -y gpg wget
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - > /usr/share/keyrings/kitware-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ bionic main' > /etc/apt/sources.list.d/kitware.list
apt-get update
rm /usr/share/keyrings/kitware-archive-keyring.gpg
apt-get install -y kitware-archive-keyring
# Enable https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa to get
# up-to-date packages for Python 3.7
apt-get install -y software-properties-common # add-apt-repository
add-apt-repository -y ppa:deadsnakes/ppa
apt-get install -y python3.7-dev python3.7-venv
export NRN_PYTHON=$(command -v python3.7)
echo "NRN_PYTHON=${NRN_PYTHON}" >> $GITHUB_ENV
