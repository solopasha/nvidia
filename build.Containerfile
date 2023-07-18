ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG NVIDIA_MAJOR_VERSION="${NVIDIA_MAJOR_VERSION:-535}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

RUN ln -s /usr/bin/rpm-ostree /usr/bin/dnf

COPY build-akmods.sh /tmp/build-akmods.sh

ADD certs /tmp/certs

ADD ublue-os-nvidia-addons.spec /tmp/ublue-os-nvidia-addons/ublue-os-nvidia-addons.spec

ADD https://nvidia.github.io/nvidia-docker/rhel9.0/nvidia-docker.repo \
    /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/nvidia-container-runtime.repo

ADD https://nvidia.github.io/nvidia-docker/rhel9.0/nvidia-docker.repo \
    /etc/yum.repos.d/nvidia-container-runtime.repo

ADD files/etc/nvidia-container-runtime/config-rootless.toml \
    /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/config-rootless.toml
ADD https://raw.githubusercontent.com/NVIDIA/dgx-selinux/master/bin/RHEL9/nvidia-container.pp \
    /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/nvidia-container.pp
ADD files/etc/sway/environment /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/environment

RUN /tmp/build-akmods.sh

RUN rpm -ql /tmp/ublue-os-nvidia-addons/rpmbuild/RPMS/*/*.rpm

FROM scratch

COPY --from=builder /var/cache/akmods /var/cache/akmods
COPY --from=builder /tmp/ublue-os-nvidia-addons /tmp/ublue-os-nvidia-addons
