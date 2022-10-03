#
# Copyright (C) 2020-2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

COMMON_PATH := device/samsung/universal9611-common

## Include path
TARGET_SPECIFIC_HEADER_PATH := $(COMMON_PATH)/include

## Inherit proprietary vendor configuartion
include vendor/samsung/universal9611-common/BoardConfigVendor.mk

## Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

## Architecture (Secondary)
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

## Audio
BOARD_LOW_LATENCY_CAPTURE_DURATION := 20

## Bluetooth
BOARD_HAVE_BLUETOOTH_SLSI := true

## Boot Image
BOARD_BOOTIMG_HEADER_VERSION := 2
BOARD_CUSTOM_BOOTIMG := true
BOARD_DTB_OFFSET := 0x00000000
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_SECOND_OFFSET := 0xf0000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_TAGS_OFFSET := 0x00000100
BOARD_KERNEL_CMDLINE += loop.max_part=7
TARGET_KERNEL_SOURCE := kernel/samsung/universal9611

BOARD_MKBOOTIMG_ARGS := --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --second_offset $(BOARD_SECOND_OFFSET)

# Kernel config
TARGET_KERNEL_CONFIG := $(addprefix vendor/, $(TARGET_DEVICE)_defconfig $(TARGET_DEVICE).config grass.config aosp.config)

# Broken Build Rules
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true
BUILD_BROKEN_DUP_RULES := true

## Display
BOARD_MINIMUM_DISPLAY_BRIGHTNESS := 1
TARGET_SCREEN_DENSITY := 420

## DTBO
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_DTBO_CFG := $(COMMON_PATH)/configs/kernel/$(TARGET_DEVICE).cfg

## DTB
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_CUSTOM_DTBIMG_MK := $(COMMON_PATH)/mkdtbimg.mk

## Camera
SOONG_CONFIG_NAMESPACES += samsungCameraVars
SOONG_CONFIG_samsungCameraVars += extra_ids
SOONG_CONFIG_samsungCameraVars_extra_ids := 4,20,23,50,52,54
$(call soong_config_set,samsungCameraVars,usage_64bit,true)

# libinit
TARGET_INIT_VENDOR_LIB := //$(COMMON_PATH):init_universal9611
TARGET_RECOVERY_DEVICE_MODULES := libinit_universal9611

## Graphics
TARGET_USES_VULKAN := true

## Kernel
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_KERNEL_ADDITIONAL_FLAGS := HOSTCFLAGS="-fuse-ld=lld -Wno-unused-command-line-argument"

# ART
ART_BUILD_TARGET_NDEBUG := true
ART_BUILD_TARGET_DEBUG := false
ART_BUILD_HOST_NDEBUG := true
ART_BUILD_HOST_DEBUG := false
WITH_DEXPREOPT_DEBUG_INFO := false

## Keymaster
TARGET_KEYMASTER_VARIANT := samsung

## Lineage Health
TARGET_HEALTH_CHARGING_CONTROL_CHARGING_PATH := /sys/class/power_supply/battery/batt_slate_mode
TARGET_HEALTH_CHARGING_CONTROL_CHARGING_ENABLED := 0
TARGET_HEALTH_CHARGING_CONTROL_CHARGING_DISABLED := 1
TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_BYPASS := false
TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_TOGGLE := true
TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_DEADLINE := false

## Manifest
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/configs/vintf/manifest.xml
DEVICE_MATRIX_FILE := $(COMMON_PATH)/configs/vintf/compatibility_matrix.xml

## NFC SKU
ifeq ($(filter true, $(TARGET_USES_NXP_NFC) $(TARGET_USES_SLSI_NFC)),true)
ODM_MANIFEST_SKUS := hce hceese hcesim hcesimese disabled
ifeq ($(TARGET_USES_NXP_NFC),true)
PREFIX := nxp
else
PREFIX := slsi
endif
ODM_MANIFEST_NFC_FILE := $(COMMON_PATH)/configs/nfc/odm_nfc_manifest_$(PREFIX).xml
ODM_MANIFEST_HCE_FILES := $(ODM_MANIFEST_NFC_FILE)
ODM_MANIFEST_HCEESE_FILES := $(ODM_MANIFEST_NFC_FILE)
ODM_MANIFEST_HCESIM_FILES := $(ODM_MANIFEST_NFC_FILE)
ODM_MANIFEST_HCESIMESE_FILES := $(ODM_MANIFEST_NFC_FILE)
ODM_MANIFEST_DISABLED_FILES := $(COMMON_PATH)/configs/nfc/odm_nfc_manifest_disabled_$(PREFIX).xml
endif

## Partitions
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS := efs
BOARD_ROOT_EXTRA_SYMLINKS := /efs:/factory

## Platform
BOARD_VENDOR := samsung
TARGET_BOARD_PLATFORM := universal9611
TARGET_BOOTLOADER_BOARD_NAME := exynos9611
TARGET_SOC := exynos9611
include hardware/samsung_slsi-linaro/config/BoardConfig9611.mk

## Properties
TARGET_PRODUCT_PROP += $(COMMON_PATH)/configs/prop/product.prop
TARGET_VENDOR_PROP += $(COMMON_PATH)/configs/prop/vendor.prop

## Recovery
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/configs/init/fstab.exynos9611
TARGET_RECOVERY_PIXEL_FORMAT := "ABGR_8888"

## Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := $(COMMON_PATH)/releasetools
BOARD_USES_FULL_RECOVERY_IMAGE := true

## RIL
ENABLE_VENDOR_RIL_SERVICE := true

## Security
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

## SELinux
BOARD_SEPOLICY_TEE_FLAVOR := teegris
include device/samsung_slsi/sepolicy/sepolicy.mk

BOARD_VENDOR_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/vendor
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/public

# Vibrator
$(call soong_config_set,samsungVibratorVars,duration_amplitude,true)

## USB
$(call soong_config_set,samsungUsbGadgetVars,gadget_name,13200000.dwc3)

## Wi-Fi
BOARD_WLAN_DEVICE                := slsi
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_slsi
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_slsi
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION           := VER_0_8_X

PRODUCT_CFI_INCLUDE_PATHS += hardware/samsung_slsi/scsc_wifibt/wpa_supplicant_lib
