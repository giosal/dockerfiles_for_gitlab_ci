#!/usr/bin/env bash

set -euo pipefail

apk --update --no-cache add \
    autoconf \
    bash \
    build-base \
    ca-certificates \
    curl \
    file \
    g++ \
    gcc \
    git \
    grep \
    jq \
    libc-dev \
    libffi-dev \
    make \
    openssh-client \
    openssl \
    openssl-dev \
    patch \
    rsync \
    sshpass \
    sudo \
    tar \
    unzip \
    wget \
    xz \
    zip

pip install --no-cache-dir --upgrade pip setuptools wheel
