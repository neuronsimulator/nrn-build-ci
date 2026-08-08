#!/usr/bin/env bash

# install a compatible version of ccache

set -euxo pipefail

ccache_version='4.11.3'
ccache_srcdir="ccache-${ccache_version}"
ccache_builddir="ccache-build"
wget "https://github.com/ccache/ccache/releases/download/v${ccache_version}/ccache-${ccache_version}.tar.gz"
tar xf "ccache-${ccache_version}.tar.gz"
cmake -B "${ccache_builddir}" -S "${ccache_srcdir}"
cmake --build "${ccache_builddir}" --parallel
cmake --install "${ccache_builddir}"
