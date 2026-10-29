#!/usr/bin/env bash

set -euo pipefail

apk del --purge grep file openssl-dev 2>/dev/null || true

rm -rf /tmp/* \
       /usr/includes/* \
       /usr/share/man/* \
       /var/cache/apk/* \
       /var/tmp/*
