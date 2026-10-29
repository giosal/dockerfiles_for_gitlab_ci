ARG PYTHON_VERSION=3.13

FROM python:${PYTHON_VERSION}-alpine

ARG PYTHON_VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="George Salukvadze <gsalukvadze@iotlab.com>" \
  PYTHON="${PYTHON_VERSION}" \
  org.label-schema.name="giosal/dockerfiles_for_gitlab_ci" \
  org.label-schema.description=":snake: Docker images for building and testing Python applications with Gitlab CI (or any other CI platform!)" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/giosal/dockerfiles_for_gitlab_ci" \
  org.label-schema.vcs-ref=$VCS_REF

# Set correct environment variables
ENV IMAGE_USER=root
ENV HOME=/home/$IMAGE_USER
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

USER $IMAGE_USER

WORKDIR /tmp

COPY ./tmp/*.sh /tmp/

# Run install & cleanup scripts
RUN chmod +x /tmp/*.sh \
  && apk add --update --no-cache bash \
  && bash ./packages.sh \
  && bash ./cleanup.sh

WORKDIR /app

CMD ["python3", "-V"]
