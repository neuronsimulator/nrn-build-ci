# Scheduled CI builds for NEURON
[![NEURON Build CI](https://github.com/neuronsimulator/nrn-build-ci/actions/workflows/build-neuron.yml/badge.svg)](https://github.com/neuronsimulator/nrn-build-ci/actions/workflows/build-neuron.yml)

This repository hosts [scheduled GitHub Actions workflows](.github/workflows/neuron-ci.yaml) that verify that [the main NEURON repository](https://github.com/neuronsimulator/nrn) can be built and run on a variety of common Linux distributions and macOS versions.
The default branch of NEURON (and `neuron-nightly` wheel) is tested every night,
and the latest tagged release (and corresponding `neuron` wheel) is tested once
a week.
At present, Ubuntu 22.04, Ubuntu 24.04, Fedora 37, Fedora 40, CentOS Stream
9, Alma Linux 8, Debian Bullseye (11), Debian Bookworm (12), macOS 12 and
macOS 13 are tested.

The tested distributions are generally configured with the explicit
name/version of the second-newest version of the distribution at the time,
while a generic "latest" tag is used for the latest version (where available).

This means that when a new version of a distribution is released, we
automatically start testing it.
When this happens, the old second-newest version generally becomes the
third-newest version, and must be manually updated via pull request.
This is often an opportunity to drop some version-specific scripts.
The `fedora:latest` build is particulally useful, as Fedora has a relatively
fast release cadence and often includes cutting-edge compilers and library
versions; this means we can often spot issues via this build before they
trickle down to other CI configurations and users in the community.

The configuration of these builds serves as an up-to-date reference of how to build NEURON on each platform.

## System package installation
The system packages needed on each platform are listed in the pair of scripts:
```
scripts/install_{flavour}_{container}.sh [this file may be missing if no container-specific setup is needed]
scripts/install_{flavour}.sh
```
Taking Alma Linux 8 (a RedHat based distribution) as an example, the scripts [install_redhat_almalinux_8_10.sh](scripts/install_redhat_almalinux_8_10.sh) and [install_redhat.sh](scripts/install_redhat.sh) install the required system packages that are not already included in the [almalinux:8.10](https://hub.docker.com/_/almalinux) image on Docker Hub.

Some of the content of these scripts is specific to the GitHub Actions environment in which they are regularly tested; this is commented in the following way:
```sh
# ---
# --- Begin GitHub-Actions-specific code ---
# ---
some_command_to_make_github_actions_work
# ---
# --- End GitHub-Actions-specific code ---
# ---
```
and need not be copied when these scripts are used as references for local installations.

## Runtime environment
In a similar way, modifications to the runtime environment are listed in the scripts:
```
scripts/environment_{flavour}_{container}.sh [this may be missing]
scripts/environment_{flavour}.sh             [this may be missing]
scripts/environment.sh
```
In a local installation, you might prefer to place these commands in a `~/.bashrc` or `~/.zshrc` file.

When using RedHat-derived Linux distributions, such as Fedora and CentOS Stream, some dependencies may be made available using [Software Collections](https://www.softwarecollections.org/en/).
These are enabled using the `scl enable collection_name command`, which launches a subshell and cannot trivially be included in the `environmentXXX.sh` scripts above.
For interactive use, one can simply run
```
scl enable collection_name bash
```
to get a shell with the given collection enabled.
> When running in GitHub Actions, the `scl enable ...` command is injected in the [runUnprivileged.sh](wrappers/runUnprivileged.sh) wrapper, based on `SOFTWARE_COLLECTIONS_*` environment modules set in the [top-level YAML configuration](.github/workflows/neuron-ci.yaml).

## Extra dependencies and NEURON installation
The installation of extra packages (via `pip`) and the installation of NEURON itself is steered by the [buildNeuron.sh](scripts/buildNeuron.sh) script.
This closely mirrors the instructions [in the main NEURON repository](https://github.com/neuronsimulator/nrn/#build-cmake).

# Azure wheels testing - Manual workflow

Given an Azure build (PR, master, ...), it is possible to test those specific wheels on the different platforms covered by this CI.
The azure build publishes an artifact called `drop`, which contains all wheels built by the pipeline.

Here are the steps to follow: 

* Retrieve the Azure drop url

  * From the azure build page, click on `published`:
    
    ![](images/drop1.png)
  * then from the artifact page retrieve the drop download url:
    
    ![](images/drop2.png)

* Launch the CI manually
  1) click on `Actions` tab
  2) click on `Scheduled NEURON CI` tab under `Workflows`
  3) click on `Run workflow`
  4) input `Azure drop (artifacts) url` and click `Run workflow` (leave `NEURON branch to test`) blank.
     
  ![](images/manual-dispatch.png)

# Testing a NEURON feature branch
By default the GitHub Actions workflow in this repository runs every night, and on modifications made to the `nrn-build-ci` repository itself.
You can also use the same workflow to manually trigger testing a feature branch of NEURON, for example if you have a NEURON pull request that is fixing an issue identified by one of the scheduled builds in this repository.
In that case, follow the instructions just above to launch a manual job, but instead of filling the `Azure drop (artifacts) url`, leave that blank and put the name of your NEURON feature branch in `NEURON branch to test`.
