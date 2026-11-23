#!/usr/bin/env bash

set -euo pipefail

apk --update --no-cache add \
	autoconf \
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
    make \
    nodejs \
    npm \
    openssh-client \
    openssl \
    openssl-dev \
    patch \
    python3 \
    rsync \
    sudo \
	tar \
	xz \
    zip
