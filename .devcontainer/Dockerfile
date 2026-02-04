FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git python3 python3-dev python3-pip python3-venv flex bison nasm iasl uuid-dev uuid-runtime \
    qemu-utils wget curl ca-certificates pkg-config libssl-dev libncurses5-dev make \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu gcc-arm-none-eabi binutils-aarch64-linux-gnu \
    crossbuild-essential-arm64 libc6-dev-arm64-cross libfdt-dev device-tree-compiler \
    seabios ovmf qemu-efi libglib2.0-dev libgtk-3-dev libepoxy-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy edk2 pip requirements from workspace and install if present
COPY ./edk2/pip-requirements.txt /tmp/pip-requirements.txt
RUN if [ -f /tmp/pip-requirements.txt ]; then python3 -m pip install --upgrade pip && python3 -m pip install -r /tmp/pip-requirements.txt; fi
RUN pip install tomli ninja

WORKDIR /workspaces/odp-edk2

USER vscode
