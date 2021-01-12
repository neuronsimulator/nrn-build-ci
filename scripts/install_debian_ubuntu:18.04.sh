#!/bin/bash
# ---
# --- Begin GitHub-Actions-specific code ---
# ---
# The default Git is too old for the GitHub Actions checkout module. This
# enables a package repository that provides a newer one.
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:git-core/ppa
# ---
# --- End GitHub-Actions-specific code ---
# ---
