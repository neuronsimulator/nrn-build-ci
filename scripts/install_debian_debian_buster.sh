# Install a more recent version of CMake
echo 'deb http://deb.debian.org/debian buster-backports main' >> /etc/apt/sources.list
apt-get update
apt-get install -t buster-backports -y cmake
# Set MPICH to be the default MPI
apt-get install -y mpich
update-alternatives --set mpi /usr/bin/mpicc.mpich
