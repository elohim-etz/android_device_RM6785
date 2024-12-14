#
# Copyright (C) 2021-2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)

# Inherit from device makefile
$(call inherit-product, device/realme/RM6785/device.mk)

# Inherit some common MikuUI stuff.
$(call inherit-product, vendor/miku/build/product/miku_product.mk)

# Miku UI additions
MIKU_GAPPS := false
TARGET_WITH_KERNEL_SU := true
MIKU_MASTER := 𝙴𝙻𝙾𝙷𝙸𝙼


# Device identifier. This must come after all inclusions.
PRODUCT_NAME := miku_RM6785
PRODUCT_DEVICE := RM6785
PRODUCT_BRAND := realme
PRODUCT_MODEL := RM6785
PRODUCT_MANUFACTURER := realme
PRODUCT_GMS_CLIENTID_BASE := android-oppo

DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay-miku

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME="RM6785"