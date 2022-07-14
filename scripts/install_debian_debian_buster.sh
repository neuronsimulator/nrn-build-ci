# Install a more recent version of CMake
echo 'deb http://deb.debian.org/debian buster-backports main' >> /etc/apt/sources.list
apt-get update
apt-get install -t buster-backports -y cmake
DO_NOT_INSTALL_BOOST=true
