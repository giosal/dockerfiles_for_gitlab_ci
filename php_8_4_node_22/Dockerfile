ARG PHP_VERSION=8.4
ARG NODE_VERSION=22
ARG NPM_VERSION=latest
ARG YARN_VERSION=4.6.0

FROM node:${NODE_VERSION}-alpine AS node
FROM php:${PHP_VERSION}-alpine

ARG PHP_VERSION
ARG NODE_VERSION
ARG NPM_VERSION
ARG YARN_VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="George Salukvadze <gsalukvadze@iotlab.com>" \
  PHP="${PHP_VERSION}" \
  NODE="${NODE_VERSION}" \
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
ENV NODE_VERSION=${NODE_VERSION}
ENV NPM_VERSION=${NPM_VERSION}
ENV YARN_VERSION=${YARN_VERSION}
ENV PHP_VERSION=${PHP_VERSION}

USER $IMAGE_USER

WORKDIR /tmp

COPY ./tmp/*.sh /tmp/
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /usr/lib/lib* /usr/lib/

# COPY INSTALL SCRIPT
RUN chmod +x /tmp/*.sh \
  && ln -sf /usr/local/bin/node /usr/bin/node \
  && apk add --update --no-cache bash \
  && bash ./packages.sh \
  && bash ./extensions.sh \
  && bash ./nodeyarn.sh \
  && rm -rf ~/.composer/cache/* \
  && chown -R $IMAGE_USER:$IMAGE_USER /var/www $HOME \
  && bash ./cleanup.sh

WORKDIR /var/www/html

CMD ["php", "-a"]
