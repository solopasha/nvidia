#!/bin/bash

set -ouex pipefail

mapfile -t INCLUDED_PACKAGES < <(jq -r "[(.all.include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/packages.json)
mapfile -t EXCLUDED_PACKAGES < <(jq -r "[(.all.exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/packages.json)


if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    mapfile -t EXCLUDED_PACKAGES < <(rpm -qa --queryformat='%{NAME} ' "${EXCLUDED_PACKAGES[@]}")
fi


# rpm-ostree install /tmp/akmods-rpms/ublue-os/ublue-os-akmods-addons*.rpm
# for REPO in $(rpm -ql ublue-os-akmods-addons|grep ^"/etc"|grep repo$); do
#     echo "akmods: enable default entry: ${REPO}"
#     sed -i '0,/enabled=0/{s/enabled=0/enabled=1/}' ${REPO}
# done

# rpm-ostree install /tmp/akmods-rpms/kmods/*.rpm

# for REPO in $(rpm -ql ublue-os-akmods-addons|grep ^"/etc"|grep repo$); do
#     echo "akmods: disable per defaults: ${REPO}"
#     sed -i 's@enabled=1@enabled=0@g' ${REPO}
# done

if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#EXCLUDED_PACKAGES[@]}" -eq 0 ]]; then
    rpm-ostree install \
        ${INCLUDED_PACKAGES[@]}

elif [[ "${#INCLUDED_PACKAGES[@]}" -eq 0 && "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]}

elif [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]} \
        $(printf -- "--install=%s " ${INCLUDED_PACKAGES[@]})

else
    echo "No packages to install."

fi
