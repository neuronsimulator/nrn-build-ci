set -eux
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
export HOMEBREW_NO_INSTALL_UPGRADE=1
brew install bison boost coreutils flex mpich ninja xz wget
brew unlink mpich
brew install openmpi
brew install --cask xquartz
