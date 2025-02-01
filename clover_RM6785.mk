#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)

# Inherit from device makefile
$(call inherit-product, device/realme/RM6785/device.mk)

# Inherit some common Clover stuff.
$(call inherit-product, vendor/clover/config/common_full_phone.mk)

# Project Clover Flags
CLOVER_BUILDTYPE := UNOFFICIAL
WITH_GMS := false
TARGET_BUILD_VARIANT := user
TARGET_FACE_UNLOCK_SUPPORTED := true

# Boot animation
TARGET_BOOT_ANIMATION_RES := 1080

PRODUCT_NAME := clover_RM6785
PRODUCT_DEVICE := RM6785
PRODUCT_BRAND := realme
PRODUCT_MODEL := RM6785
PRODUCT_MANUFACTURER := realme
PRODUCT_GMS_CLIENTID_BASE := android-oppo

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="sys_oplus_mssi_64_cn-user 11 RP1A.200720.011 1623809323039 release-keys" \
    BuildFingerprint=realme/RMX2002/RMX2002L1:11/RP1A.200720.011/1651754371157:user/release-keys \
    DeviceProduct=RM6785 \