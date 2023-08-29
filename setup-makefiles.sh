#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

export DEVICE=RM6785
export VENDOR=realme

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

LINEAGE_ROOT="${MY_DIR}/../../.."

HELPER="${LINEAGE_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function vendor_imports() {
    cat <<EOF >>"$1"
		"device/realme/RM6785",
		"hardware/mediatek",
		"hardware/mediatek/libmtkperf_client",
EOF
}

# Initialize the helper for device
setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${LINEAGE_ROOT}" true

# Copyright headers and common guards
write_headers

# The standard blobs
write_makefiles "${MY_DIR}/proprietary-files.txt" true

# Append the calls to firmware images
append_firmware_calls_to_makefiles "${MY_DIR}/proprietary-firmware.txt"

# Finish
write_footers
