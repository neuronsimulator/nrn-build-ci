set -eux
# Temporary fix, see https://github.com/actions/setup-python/issues/577
rm /usr/local/bin/2to3 || true
rm /usr/local/bin/idle3 || true
rm /usr/local/bin/pydoc3 || true
rm /usr/local/bin/python3 || true
rm /usr/local/bin/python3-config || true
brew install bison boost coreutils flex mpich ninja xz wget
brew unlink mpich
brew install openmpi
brew install --cask xquartz
