#!/bin/bash
# Disable some python wheel tests on macOS
export SKIP_EMBEDED_PYTHON_TEST=true
# Do not enable OpenMP on macOS
export CORENRN_ENABLE_OPENMP=OFF
# Use Flex from homebrew
export PATH=/usr/local/opt/flex/bin:${PATH}
