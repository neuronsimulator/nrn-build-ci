# Inspired by https://github.com/open-mpi/ompi/issues/11295 to try and
# avoid hangs when running MPI tests.
set -x
export FI_PROVIDER="tcp"
