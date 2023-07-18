#!/bin/bash

set -ouex pipefail

mv /etc/nvidia-container-runtime/config.toml{,.orig}
cp /etc/nvidia-container-runtime/config{-rootless,}.toml

semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp

if [[ "${IMAGE_NAME}" == "sericea" ]]; then
    mv /etc/sway/environment{,.orig}
    install -Dm644 /usr/share/ublue-os/etc/sway/environment /etc/sway/environment
fi

systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer

systemctl --global enable flatpak-user-update.timer

cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf
