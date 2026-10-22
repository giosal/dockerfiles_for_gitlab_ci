#!/usr/bin/env bash

set -euo pipefail

npm i -g --force npm@"${NPM_VERSION:-latest}"
npm i -g --force corepack

touch ~/.bashrc

corepack enable
if [[ "${YARN_VERSION:-latest}" == "latest" || "${YARN_VERSION:-latest}" == "stable" ]]; then
  corepack prepare yarn@stable --activate
else
  corepack prepare "yarn@${YARN_VERSION}" --activate
fi

rm -rf /usr/share/man /var/cache/apk/* \
  /root/.npm /root/.node-gyp /root/.gnupg /usr/lib/node_modules/npm/man \
  /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts
