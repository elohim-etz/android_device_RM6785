echo 'Starting to clone stuffs needed for your device'
echo 'Cloning RM6785 Vendor tree [1/4]'
# Vendor
rm -rf vendor/realme/RM6785-common
if [ ! -d "vendor/realme/RM6785-common" ]; then
    mkdir -p vendor/realme/RM6785-common
    git clone https://github.com/realme-mt6785-devs/proprietary_vendor_realme_RM6785-common -b lineage-21 vendor/realme/RM6785-common
    sed -i 's/RMX2001L1 RMX2151L1/& RM6785/' vendor/realme/RM6785-common/Android.mk
fi

echo 'Cloning Kernel tree [2/4]'
# Kernel
rm -rf kernel/realme/mt6785
if [ ! -d "kernel/realme/mt6785" ]; then
    mkdir -p kernel/realme/mt6785
    git clone https://github.com/EvilAnsh/android_kernel_realme_mt6785 -b lineage-21 kernel/realme/mt6785
fi

echo 'Cloning Mediatek SEpolicy_vndr [3/4]'
# SEpolicy
rm -rf device/mediatek/sepolicy_vndr
if [ ! -d "device/mediatek/sepolicy_vndr" ]; then
    mkdir -p device/mediatek/sepolicy_vndr
    git clone https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr.git -b lineage-21 device/mediatek/sepolicy_vndr 
fi

echo 'Cloning Hardware Mediatek [4/4]'
# Hardware
rm -rf hardware/mediatek
if [ ! -d "hardware/mediatek" ]; then
    mkdir -p hardware/mediatek
    git clone https://github.com/LineageOS/android_hardware_mediatek.git -b lineage-21 hardware/mediatek
fi

echo 'Completed, Now proceeding to lunch'
