FROM node:20.18.1-alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="George Salukvadze <gsalukvadze@iotlab.com>" \
  PHP="8.3" \
  NODE="20" \
  org.label-schema.name="giosal/dockerfiles_for_gitlab_ci" \
  org.label-schema.description=":coffee: Docker images for building and testing Node applications with Gitlab CI (or any other CI plataform!)" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/giosal/dockerfiles_for_gitlab_ci" \
  org.label-schema.vcs-ref=$VCS_REF

# Set correct environment variables
ENV IMAGE_USER=root
ENV HOME=/home/$IMAGE_USER
ENV PATH=$HOME/.yarn/bin:$PATH
ENV GOSS_VERSION="0.4.4"
ENV NODE_VERSION=lts
ENV NPM_VERSION=latest
ENV YARN_VERSION=1.22.22

USER $IMAGE_USER

WORKDIR /tmp

COPY ./tmp/*.sh /tmp/
RUN apk update && apk add bash

RUN ls -al /var

# COPY INSTALL SCRIPT
RUN chmod +x /tmp/*.sh \
  && apk add --update --no-cache bash \
  && bash ./packages.sh \
  && bash ./nodeyarn.sh \
  && apk add yarn \
  && mkdir /var/www \
  && chown -R $IMAGE_USER:$IMAGE_USER /var/www $HOME \
  && curl -fsSL https://goss.rocks/install | GOSS_VER=v${GOSS_VERSION} sh \
  && bash ./cleanup.sh \
  && mkdir /var/www/html

WORKDIR /var/www/html
