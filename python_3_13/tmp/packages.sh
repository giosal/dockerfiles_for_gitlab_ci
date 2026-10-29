#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    build-essential \
    ca-certificates \
    curl \
    file \
    g++ \
    gcc \
    git \
    grep \
    jq \
    libc6-dev \
    libffi-dev \
    libpq-dev \
    libssl-dev \
    make \
    openssh-client \
    openssl \
    patch \
    pkg-config \
    rsync \
    sshpass \
    sudo \
    tar \
    unzip \
    wget \
    xz-utils \
    zip

pip install --no-cache-dir --upgrade pip setuptools wheel
