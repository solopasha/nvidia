ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"
ARG IMAGE_NAME="${IMAGE_NAME}"
ARG AKMODS_CACHE="ghcr.io/solopasha/akmods-nvidia-ublue"
ARG AKMODS_VERSION="38"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"
ARG NVIDIA_MAJOR_VERSION="535"

COPY --from=${AKMODS_CACHE}:${AKMODS_VERSION}-${NVIDIA_MAJOR_VERSION} / .

ADD install.sh /tmp/install.sh
ADD build-main.sh /tmp/build-main.sh
ADD post-install.sh /tmp/post-install.sh
ADD packages.json /tmp/packages.json

COPY --from=ghcr.io/solopasha/config:latest /rpms /tmp/rpms

RUN /tmp/install.sh && rpm-ostree cleanup -m
RUN /tmp/build-main.sh && rpm-ostree cleanup -m
RUN /tmp/post-install.sh && rpm-ostree cleanup -m
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
