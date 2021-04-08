#!/bin/bash
# Set up the runtime environment by sourcing the environmentXXX.sh scripts.
# For a local installation you might have put the content of those scripts
# directly into your ~/.bashrc or ~/.zshrc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT_DIR}/environment.sh"

# Choose which Python version to use
export PYTHON=$(command -v python3)

# Install extra dependencies for NEURON
# Make sure we have a modern pip, old ones may not handle dependency versions
# correctly
${PYTHON} -m pip install --user --upgrade pip
${PYTHON} -m pip install --user --upgrade bokeh cython ipython matplotlib \
  mpi4py pytest pytest-cov scikit-build

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
export CMAKE_OPTION="-DNRN_ENABLE_BINARY_SPECIAL=ON -DNRN_ENABLE_MPI=ON \
 -DNRN_ENABLE_INTERVIEWS=ON -DNRN_ENABLE_CORENEURON=ON \
 -DPYTHON_EXECUTABLE=${PYTHON} -DCMAKE_C_COMPILER=${CC} \
 -DCMAKE_CXX_COMPILER=${CXX} -DNRN_ENABLE_TESTS=ON \
 -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}"
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
# The --parallel option to CMake was only added in v3.12
cmake --build . -- -j ${PARALLEL_JOBS}

echo "------- Install NEURON -------"
make install

echo "------- Run test suite -------"
ctest -VV -j ${PARALLEL_JOBS}
