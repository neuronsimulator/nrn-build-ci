#!/bin/bash
# Set up the runtime environment by sourcing the environmentXXX.sh scripts.
# For a local installation you might have put the content of those scripts
# directly into your ~/.bashrc or ~/.zshrc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT_DIR}/environment.sh"

# Choose which Python version to use. If an installation script set NRN_PYTHON,
# use that.
export PYTHON=${NRN_PYTHON:-$(command -v python3)}

# Set up a virtual environment. On some distros (Ubuntu 18.04 + Python 3.7) we
# only get venv from the system packages, not pip.
${PYTHON} -m venv nrn_venv
. nrn_venv/bin/activate

# Make sure we have a modern pip, old ones may not handle dependency versions
# correctly
pip install --upgrade pip

# Use the virtual environment python instead of the system one it redirects to
export PYTHON=$(command -v python)

# nrniv -python does not copy properly with virtualenvs
export PYTHONPATH=$(${PYTHON} -c 'import site; print(":".join(site.getsitepackages()))')

# Install extra dependencies for NEURON into the virtual environment.
# Apply workaround for mpi4py OOM issue on Fedora 37 and Debian 12
if [[ -n "${CFLAGS:-}" ]]; then
    old_CFLAGS="${CFLAGS}"
fi
export CFLAGS='-O0'
pip install --upgrade -r nrn_requirements.txt
if [[ -f ci_requirements.txt ]]; then
  pip install --upgrade -r ci_requirements.txt
else
  pip install --upgrade plotly "ipywidgets>=7.0.0"
fi
if [[ -f external/nmodl/requirements.txt ]]; then
  pip install --upgrade -r external/nmodl/requirements.txt
fi
if [[ -n "${old_CFLAGS:-}" ]]; then
    export CFLAGS="${old_CFLAGS}"
fi
# Needed for installation of older NEURON versions with Python 12
pip install --upgrade setuptools

install_ccache() {
    ccache_version='4.11.3'
    ccache_srcdir="ccache-${ccache_version}"
    ccache_builddir="ccache-build"
    wget "https://github.com/ccache/ccache/releases/download/v${ccache_version}/ccache-${ccache_version}.tar.gz"
    tar xf "ccache-${ccache_version}.tar.gz"
    cmake -B "${ccache_builddir}" -S "${ccache_srcdir}"
    cmake --build "${ccache_builddir}" --parallel
    sudo cmake --install "${ccache_builddir}"
}

# Set default compilers, but don't override preset values
export CC=${CC:-gcc}
export CXX=${CXX:-g++}

# Some logging
echo LANG=${LANG}, LC_ALL=${LC_ALL}
echo PATH=${PATH}
echo CC=${CC} \($(command -v ${CC})\) version $(${CC} -dumpversion)
echo CXX=${CXX} \($(command -v ${CXX})\), version $(${CXX} -dumpversion)
echo git \($(command -v git)\) version $(git --version | cut -d ' ' -f 3-)
echo python \(${PYTHON}\) version $(${PYTHON} --version | cut -d ' ' -f 2-)
echo CMake \($(command -v cmake)\)
cmake --version
${PYTHON} -c 'import os, sys; os.set_blocking(sys.stdout.fileno(), True)'

echo "------- Configuring NEURON -------"
export CMAKE_OPTION="-G Ninja \
 -DNRN_ENABLE_MPI=ON -DNRN_ENABLE_INTERVIEWS=ON \
 -DNRN_ENABLE_CORENEURON=ON -DPYTHON_EXECUTABLE=${PYTHON} \
 -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} \
 -DNRN_ENABLE_TESTS=ON -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
 -DCORENRN_ENABLE_OPENMP=${CORENRN_ENABLE_OPENMP:-ON} \
 -DCMAKE_C_COMPILER_LAUNCHER=ccache \
 -DCMAKE_CXX_COMPILER_LAUNCHER=ccache"
echo "CMake options: ${CMAKE_OPTION}"
mkdir build && cd build
cmake ${CMAKE_OPTION} ..

echo "------- Build NEURON -------"
# Autodetection does not seem to work well, compiler processes were getting killed.
# These core counts are taken from
# https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#supported-runners-and-hardware-resources
if [ "${OS_FLAVOUR}" == "macOS" ]; then
  PARALLEL_JOBS=3
else
  PARALLEL_JOBS=2
fi
cmake --build . --parallel ${PARALLEL_JOBS}

echo "------- Install NEURON -------"
cmake --build . -- install

echo "------- Run test suite -------"
ctest -VV -j ${PARALLEL_JOBS}
