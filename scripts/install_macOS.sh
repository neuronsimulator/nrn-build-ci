set -eux
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=''
export HOMEBREW_NO_INSTALL_UPGRADE=''
brew install bison boost coreutils flex mpich ninja xz wget
brew unlink mpich
brew install openmpi
brew install --cask xquartz
