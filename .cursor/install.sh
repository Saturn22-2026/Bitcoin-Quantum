#!/usr/bin/env bash
#
# Cloud Agent environment bootstrap for Bitcoin Core.
# Installs system build dependencies and compiles the project.
# Safe to run repeatedly: apt installs are idempotent and the CMake
# build reuses its cache (accelerated by ccache).

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

# ccache cache lives inside the workspace so it survives snapshots and
# speeds up incremental rebuilds.
export CCACHE_DIR="${CCACHE_DIR:-/workspace/.ccache}"

# System dependencies for a full-featured Linux build:
#   build-essential cmake pkgconf python3 -> required toolchain
#   libboost-dev                          -> required
#   libsqlite3-dev                        -> wallet support
#   libzmq3-dev                           -> ZMQ notifications
#   libcapnp-dev capnproto                -> multiprocess/IPC support
#   python3-zmq                           -> functional test ZMQ interface
#   ccache                                -> faster rebuilds
sudo apt-get update -qq
sudo apt-get install --no-install-recommends -y \
  build-essential \
  cmake \
  pkgconf \
  python3 \
  python3-pip \
  libboost-dev \
  libsqlite3-dev \
  libzmq3-dev \
  libcapnp-dev \
  capnproto \
  python3-zmq \
  ccache

# Configure the build. Bitcoin Core defaults to GCC; the default image's
# `c++` alternative points at clang, which cannot locate libstdc++ here, so
# we pin the GNU toolchain explicitly. ZMQ is enabled to match the project's
# default feature set; wallet and IPC are on by default.
cmake -B build \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_CXX_COMPILER=g++ \
  -DWITH_ZMQ=ON \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache

# Compile all default targets (daemon, node, cli, tx, util, wallet, unit tests).
cmake --build build -j"$(nproc)"
