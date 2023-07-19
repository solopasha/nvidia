#!/bin/bash

set -ouex pipefail

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-{updates-archive,modular,updates-modular}.repo

rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm \
    /tmp/rpms/*.rpm #\
    # fedora-repos-archive

install -D /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/nvidia-container-runtime.repo \
    /etc/yum.repos.d/nvidia-container-runtime.repo

# shellcheck source=/dev/null
source /var/cache/akmods/nvidia-vars

rpm-ostree install \
    xorg-x11-drv-"${NVIDIA_PACKAGE_NAME}"-{,cuda-,devel-,power-}"${NVIDIA_FULL_VERSION}" \
    nvidia-container-toolkit nvidia-vaapi-driver \
    "/var/cache/akmods/${NVIDIA_PACKAGE_NAME}/kmod-${NVIDIA_PACKAGE_NAME}-${KERNEL_VERSION}-${NVIDIA_AKMOD_VERSION}.fc${RELEASE}.rpm" \
    /tmp/ublue-os-nvidia-addons/rpmbuild/RPMS/noarch/ublue-os-nvidia-addons-*.rpm

