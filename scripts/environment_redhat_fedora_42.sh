# Inspired by https://github.com/open-mpi/ompi/issues/11295 to try and
# avoid hangs when running MPI tests.
export FI_PROVIDER="tcp"
# Some segfaults on Fedora 42
export UCX_TLS=tcp,self
export OMPI_MCA_btl=^openib
