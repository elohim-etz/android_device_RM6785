#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)

# Inherit from device makefile
$(call inherit-product, device/realme/RM6785/device.mk)

# Inherit some common Infinity stuff.
$(call inherit-product, vendor/infinity/config/common_full_phone.mk)

TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_SUPPORTS_QUICK_TAP := true
TARGET_SUPPORTS_CALL_RECORDING := true

# Infinity-X Flags
INFINITY_BUILD_TYPE := UNOFFICIAL
INFINITY_MAINTAINER := 𝙴𝙻𝙾𝙷𝙸𝙼
TARGET_SUPPORTS_BLUR := false
TARGET_HAS_UDFPS := false
WITH_GAPPS := false

# Boot animation
TARGET_BOOT_ANIMATION_RES := 1080

PRODUCT_NAME := infinity_RM6785
PRODUCT_DEVICE := RM6785
PRODUCT_BRAND := realme
PRODUCT_MODEL := RM6785
PRODUCT_MANUFACTURER := realme
PRODUCT_GMS_CLIENTID_BASE := android-oppo

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="sys_oplus_mssi_64_cn-user 11 RP1A.200720.011 1623809323039 release-keys" \
    BuildFingerprint=realme/RMX2002/RMX2002L1:11/RP1A.200720.011/1651754371157:user/release-keys \
    DeviceProduct=RM6785 \