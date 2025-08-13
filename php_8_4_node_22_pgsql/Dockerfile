FROM php:8.4-alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="George Salukvadze <gsalukvadze@iotlab.com>" \
  PHP="8.4" \
  NODE="22" \
  org.label-schema.name="giosal/dockerfiles_for_gitlab_ci" \
  org.label-schema.description=":coffee: Docker images for building and testing PHP applications with Gitlab CI (or any other CI plataform!)" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/giosal/dockerfiles_for_gitlab_ci" \
  org.label-schema.vcs-ref=$VCS_REF

# Set correct environment variables
ENV IMAGE_USER=root
ENV HOME=/home/$IMAGE_USER
ENV COMPOSER_HOME=$HOME/.composer
ENV PATH=$HOME/.yarn/bin:$PATH
ENV GOSS_VERSION="0.4.4"
ENV NODE_VERSION=22
ENV NPM_VERSION=latest
ENV YARN_VERSION=4.6.0
ENV PHP_VERSION=8.4

USER $IMAGE_USER

WORKDIR /tmp

COPY ./tmp/*.sh /tmp/
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=library/node:alpine /usr/local/bin/node /usr/bin/
COPY --from=library/node:alpine /var/lib/libgcc* /var/lib/libstdc* /usr/lib/* /usr/lib/
RUN apk update && apk add bash

# COPY INSTALL SCRIPT
RUN chmod +x /tmp/*.sh \
  && apk add --update --no-cache bash \
  && bash ./packages.sh \
  && bash ./extensions.sh \
  && bash ./nodeyarn.sh \
  && rm -rf ~/.composer/cache/* \
  && chown -R $IMAGE_USER:$IMAGE_USER /var/www $HOME \
  && curl -fsSL https://goss.rocks/install | GOSS_VER=v${GOSS_VERSION} sh \
  && bash ./cleanup.sh

WORKDIR /var/www/html

CMD ["php", "-a"]
