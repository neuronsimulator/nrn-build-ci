# Dockerfile for running NEURON CI locally
# Usage examples:
#   docker build --build-arg BASE_IMAGE=almalinux:8.10 --build-arg OS_FLAVOUR=redhat -t neuron-ci .
#   docker build --build-arg BASE_IMAGE=ubuntu:22.04 --build-arg OS_FLAVOUR=debian -t neuron-ci .
#   docker build --build-arg BASE_IMAGE=fedora:37 --build-arg OS_FLAVOUR=redhat -t neuron-ci .

ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

# Build arguments
ARG OS_FLAVOUR=debian
ARG NEURON_BRANCH=""
ARG MIN_MINOR_PYTHON_VERSION=9
ARG MAX_MINOR_PYTHON_VERSION=13

# Environment variables
ENV OS_FLAVOUR=${OS_FLAVOUR}
ENV MIN_MINOR_PYTHON_VERSION=${MIN_MINOR_PYTHON_VERSION}
ENV MAX_MINOR_PYTHON_VERSION=${MAX_MINOR_PYTHON_VERSION}
ENV UNPRIVILEGED_USER=runner
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /workspace

# Copy installation scripts
COPY scripts/ /workspace/scripts/
COPY wrappers/ /workspace/wrappers/

# Determine OS container name for script selection
RUN OS_CONTAINER="${BASE_IMAGE##*/}" && \
    OS_CONTAINER="${OS_CONTAINER//[:.]/_}" && \
    echo "OS_CONTAINER=${OS_CONTAINER}" > /etc/environment && \
    export OS_CONTAINER

# Install packages based on OS flavour
RUN set -ex && \
    OS_CONTAINER="${BASE_IMAGE##*/}" && \
    OS_CONTAINER="${OS_CONTAINER//[:.]/_}" && \
    CONTAINER_SCRIPT="scripts/install_${OS_FLAVOUR}_${OS_CONTAINER}.sh" && \
    FLAVOUR_SCRIPT="scripts/install_${OS_FLAVOUR}.sh" && \
    if [ -f "${CONTAINER_SCRIPT}" ]; then \
        echo "Running container-specific script: ${CONTAINER_SCRIPT}"; \
        bash "${CONTAINER_SCRIPT}"; \
    fi && \
    if [ -f "${FLAVOUR_SCRIPT}" ]; then \
        echo "Running flavour-specific script: ${FLAVOUR_SCRIPT}"; \
        bash "${FLAVOUR_SCRIPT}"; \
    fi

# Create unprivileged user
RUN useradd --create-home --shell /bin/bash ${UNPRIVILEGED_USER} && \
    chown -R ${UNPRIVILEGED_USER}:${UNPRIVILEGED_USER} /workspace

# Clone NEURON repository
RUN if [ -n "${NEURON_BRANCH}" ]; then \
        BRANCH_OPT="--branch=${NEURON_BRANCH}"; \
    fi && \
    git clone --depth=1 --single-branch ${BRANCH_OPT} \
        https://github.com/neuronsimulator/nrn /workspace/nrn && \
    cd /workspace/nrn && \
    git submodule update --init --recursive --depth 1 && \
    chown -R ${UNPRIVILEGED_USER}:${UNPRIVILEGED_USER} /workspace/nrn

# Switch to unprivileged user
USER ${UNPRIVILEGED_USER}
WORKDIR /workspace/nrn

# Set install directory
ENV INSTALL_DIR=/workspace/nrn/install

# Default command - run the build script
CMD ["/workspace/wrappers/runUnprivileged.sh", "/workspace/scripts/buildNeuron.sh"]
