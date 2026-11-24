#!/usr/bin/env bash

set -euo pipefail

apk --update --no-cache add \
  bzip2 \
  bzip2-dev \
  cassandra-cpp-driver \
  curl-dev \
  cyrus-sasl-dev \
  freetype-dev \
  gmp-dev \
  icu-dev \
  icu-data-full \
  imagemagick \
  imagemagick-dev \
  imap-dev \
  krb5-dev \
  libbz2 \
  libedit-dev \
  libintl \
  libjpeg-turbo-dev \
  libltdl \
  libmemcached-dev \
  liboauth \
  libpng-dev \
  libtool \
  libxml2-dev \
  libxslt-dev \
  linux-headers \
  openldap-dev \
  pcre-dev \
  rabbitmq-c \
  rabbitmq-c-dev \
  readline-dev \
  sqlite-dev \
  zlib-dev

apk --update --no-cache add libzip-dev libsodium-dev oniguruma-dev

# Core extensions
if [[ $PHP_VERSION == 8.5* ]] || [ "$(php -r 'echo PHP_VERSION_ID;')" -ge 80500 ]; then
  docker-php-ext-install -j "$(nproc)" exif pcntl bcmath bz2 calendar intl mbstring mysqli pdo_mysql soap xsl zip gmp
  docker-php-source delete
else
  docker-php-ext-install -j "$(nproc)" exif pcntl bcmath bz2 calendar intl mbstring mysqli opcache pdo_mysql soap xsl zip gmp
  docker-php-source delete
fi

docker-php-ext-configure gd --with-freetype --with-jpeg
docker-php-ext-install -j "$(nproc)" gd

# Third-party extensions via PIE (PECL was removed in PHP 8.6)
# Note: Switch pre-release/dev constraints back to stable once upstream PHP 8.6 releases ship.

# Prepare local PIE path repos for extensions not yet on Packagist / awaiting PHP 8.6 PR merge:
# - pecl/oauth 2.0.13 (official GitHub release; not published on Packagist yet)
git clone --depth 1 --branch 2.0.13 https://github.com/php/pecl-web_services-oauth.git /tmp/oauth
pie repository:add path /tmp/oauth

# - php-amqp/php-amqp (PHP 8.6 fix from PR #643 until merged/tagged)
mkdir -p /tmp/amqp
curl -fsSL https://github.com/php-amqp/php-amqp/archive/814bb3dd659e8c38365f4b51b8264fe82687e7be.tar.gz \
  | tar -xzC /tmp/amqp --strip-components=1
git -C /tmp/amqp init -q
git -C /tmp/amqp checkout -q -b php86-fix
git -C /tmp/amqp add -A
git -C /tmp/amqp -c user.name=ci -c user.email=ci@local commit -q -m "php86"
pie repository:add path /tmp/amqp

pie install --skip-enable-extension \
  pecl/oauth \
  xdebug/xdebug:^3.6@alpha \
  apcu/apcu:dev-master \
  imagick/imagick:dev-master \
  php-memcached/php-memcached:dev-master \
  php-amqp/php-amqp:dev-php86-fix

rm -rf /tmp/oauth /tmp/amqp "$HOME/.pie"

docker-php-ext-enable oauth xdebug apcu imagick memcached amqp

{
  echo "xdebug.mode=develop,debug,coverage"
  echo "xdebug.client_host=host.docker.internal"
  echo "xdebug.start_with_request=trigger"
} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

{
    echo 'opcache.enable=1'
    echo 'opcache.revalidate_freq=0'
    echo 'opcache.validate_timestamps=1'
    echo 'opcache.max_accelerated_files=10000'
    echo 'opcache.memory_consumption=192'
    echo 'opcache.max_wasted_percentage=10'
    echo 'opcache.interned_strings_buffer=16'
    echo 'opcache.fast_shutdown=1'
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

{
    echo 'apc.shm_segments=1'
    echo 'apc.shm_size=512M'
    echo 'apc.num_files_hint=7000'
    echo 'apc.user_entries_hint=4096'
    echo 'apc.ttl=7200'
    echo 'apc.user_ttl=7200'
    echo 'apc.gc_ttl=3600'
    echo 'apc.max_file_size=50M'
    echo 'apc.stat=1'
} > /usr/local/etc/php/conf.d/apcu-recommended.ini

echo "memory_limit=1G" > /usr/local/etc/php/conf.d/zz-conf.ini

# Verify all expected extensions are loaded
for ext in amqp apcu bcmath bz2 calendar exif gd gmp imagick intl mbstring memcached mysqli OAuth pcntl pdo_mysql soap xdebug xsl "Zend OPcache" zip; do
  if ! php -m | grep -qx "$ext"; then
    echo "ERROR: Missing PHP extension: $ext" >&2
    exit 1
  fi
done
