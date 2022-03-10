#!/bin/bash
if [ -n "${OS_CONTAINER}" ]
then
  # We are running under Docker
  if [ -z ${UNPRIVILEGED_USER+x} ]
  then
    echo "You must set the UNPRIVILEGED_USER variable."
    exit 1
  fi
  CMD_PREFIX="sudo -u ${UNPRIVILEGED_USER} --set-home"
  # Construct a variable name listing RedHat Software Collections that must be
  # enabled. This is something like SOFTWARE_COLLECTIONS_centos_7, where the
  # : separator from Docker and any . have been replaced with _
  SOFTWARE_COLLECTIONS_NAME="SOFTWARE_COLLECTIONS_${OS_CONTAINER}"
  # Get the list of software collections for this image
  SOFTWARE_COLLECTIONS="${!SOFTWARE_COLLECTIONS_NAME}"
  # If there are any, inject an `scl enable` layer into the commandline
  if [ -n "${SOFTWARE_COLLECTIONS}" ]
  then
    CMD_PREFIX="${CMD_PREFIX} scl enable ${SOFTWARE_COLLECTIONS} --"
  fi
fi
echo "Wrapper script generated command prefix: ${CMD_PREFIX}"
QUOTED_ARGS=$(printf " %q" "$@")
${CMD_PREFIX} sh -c "INSTALL_DIR=${INSTALL_DIR}\
 NEURON_BRANCH_OR_TAG=${NEURON_BRANCH_OR_TAG} OS_FLAVOUR=${OS_FLAVOUR}\
 OS_CONTAINER=${OS_CONTAINER} bash --noprofile --norc -e -o pipefail\
 --${QUOTED_ARGS}"
