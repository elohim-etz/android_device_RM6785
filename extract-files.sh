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

LINEAGE_ROOT="${MY_DIR}"/../../..

HELPER="${LINEAGE_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function blob_fixup {
    case "$1" in
        system_ext/lib64/libsource.so)
            grep -q libui_shim.so "$2" || "$PATCHELF" --add-needed libui_shim.so "$2"
            ;;
        system_ext/lib64/libimsma.so)
            [ "$2" = "" ] && return 0
            "$PATCHELF" --replace-needed "libsink.so" "libsink-mtk.so" "${2}"
            ;;
        vendor/bin/hw/android.hardware.neuralnetworks@1.3-service-mtk-neuron)
             [ "$2" = "" ] && return 0
             grep -q "libbase_shim.so" "${2}" || "${PATCHELF}" --add-needed "libbase_shim.so" "${2}"
             ;;
        vendor/etc/init/android.hardware.bluetooth@1.0-service-mediatek.rc)
            sed -i '/vts/Q' "$2"
            ;;
        vendor/lib64/libmtkcam_featurepolicy.so)
            # evaluateCaptureConfiguration()
            sed -i "s/\x34\xE8\x87\x40\xB9/\x34\x28\x02\x80\x52/" "$2"
            ;;
        vendor/lib64/hw/dfps.mt6785.so |\
        vendor/lib64/hw/vendor.mediatek.hardware.pq@2.6-impl.so)
            "$PATCHELF" --replace-needed "libutils.so" "libutils-v32.so" "$2"
            ;;
        vendor/lib/hw/audio.primary.mt6785.so)
            "$PATCHELF" --replace-needed "libmedia_helper.so" "libmedia_helper-v30.so" "$2"
            "$PATCHELF" --replace-needed "libalsautils.so" "libalsautils-v30.so" "$2"
            ;;
        vendor/lib/hw/audio.usb.mt6785.so)
            "$PATCHELF" --replace-needed "libalsautils.so" "libalsautils-v30.so" "$2"
            ;;
        vendor/lib/libmnl.so)
            [ "$2" = "" ] && return 0
            grep -q "libcutils.so" "${2}" || "${PATCHELF}" --add-needed "libcutils.so" "${2}"
            ;;
        vendor/lib64/hw/android.hardware.camera.provider@2.6-impl-mediatek.so)
            grep -q "libcamera_metadata_shim.so" "${2}" || "${PATCHELF}" --add-needed "libcamera_metadata_shim.so" "${2}"
            ;;
        vendor/lib64/lib3a.flash.so)
            [ "$2" = "" ] && return 0
            grep -q "liblog.so" "${2}" || "${PATCHELF_0_17_2}" --add-needed "liblog.so" "${2}"
            ;;
        vendor/lib64/libcam.halsensor.so)
            [ "$2" = "" ] && return 0
             grep -q "libshim_utils.so" "$2" || "$PATCHELF" --add-needed "libshim_utils.so" "$2"
            ;;
        vendor/lib64/libmtkcam_stdutils.so)
            "$PATCHELF" --replace-needed "libutils.so" "libutils-v30.so" "$2"
            ;;
        vendor/lib/libMtkOmxCore.so)
            sed -i "s/mtk.vendor.omx.core.log/ro.vendor.mtk.omx.log\x00\x00/" "$2"
            ;;
        vendor/lib/libMtkOmxVdecEx.so)
            "$PATCHELF" --replace-needed "libui.so" "libui-v32.so" "$2"
            sed -i "s/ro.mtk_crossmount_support/ro.vendor.mtk_crossmount\x00/" "$2"
            sed -i "s/ro.mtk_deinterlace_support/ro.vendor.mtk_deinterlace\x00/" "$2"
            ;;
        vendor/lib/libaudio_param_parser-vnd.so)
            sed -i "s/\x00audio.tuning.def_path/\x00ro.vendor.tuning_path/" "$2"
            sed -i "s/\x20audio.tuning.def_path/\x20ro.vendor.tuning_path/" "$2"
            ;;
        vendor/bin/mnld|\
        vendor/lib*/libaalservice.so|\
        vendor/lib64/libcam.utils.sensorprovider.so)
            grep -q "android.hardware.sensors@1.0-convert-shared.so" "$2" || "$PATCHELF" --add-needed "android.hardware.sensors@1.0-convert-shared.so" "$2"
            ;;
        vendor/lib/mediadrm/libwvdrmengine.so|vendor/lib/libwvhidl.so)
            "$PATCHELF" --replace-needed "libcrypto.so" "libcrypto_v33.so" "$2"
            ;;
        vendor/bin/hw/mtkfusionrild)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --add-needed "libutils-v32.so" "${2}"
            ;;
    esac
}

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_FIRMWARE=
SECTION=
KANG=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
	--only-firmware )
                ONLY_FIRMWARE=true
                ;;    
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

# Initialize the helper for device
setup_vendor "${DEVICE}" "${VENDOR}" "${LINEAGE_ROOT}" false "${CLEAN_VENDOR}"

if [ -z "${ONLY_FIRMWARE}" ]; then
   extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

if [ -z "${SECTION}" ]; then
    extract_firmware "${MY_DIR}/proprietary-firmware.txt" "${SRC}"
fi

"${MY_DIR}/setup-makefiles.sh"
