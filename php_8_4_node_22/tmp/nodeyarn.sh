#!/usr/bin/env bash

set -euo pipefail

npm i -g --force npm@${NPM_VERSION}
npm i -g --force corepack

touch ~/.bashrc

corepack enable
yarn set version stable
yarn install

rm -rf /usr/share/man /var/cache/apk/* \
  /root/.npm /root/.node-gyp /root/.gnupg /usr/lib/node_modules/npm/man \
  /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts
