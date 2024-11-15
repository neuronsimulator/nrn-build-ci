#!/bin/bash
# Disable some python wheel tests on macOS
export SKIP_EMBEDED_PYTHON_TEST=true
# Do not enable OpenMP on macOS
export CORENRN_ENABLE_OPENMP=OFF
# Use Bison from homebrew
PATH="$(brew --prefix)/opt/bison/bin:${PATH}"
# Use Flex from homebrew
PATH="$(brew --prefix)/opt/flex/bin:${PATH}"
export PATH
