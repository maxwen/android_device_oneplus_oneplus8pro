# Copyright (C) 2010 The Android Open Source Project
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

#
# This file is the build configuration for a full Android
# build for grouper hardware. This cleanly combines a set of
# device-specific aspects (drivers) with a device-agnostic
# product configuration (apps).
#
BOARD_PATH := device/oneplus/oneplus8pro
include $(BOARD_PATH)/BoardConfigGsi.mk

#BUILD_BROKEN_DUP_RULES := true
#BUILD_BROKEN_USES_BUILD_PREBUILT := true

TARGET_INIT_VENDOR_LIB := //$(BOARD_PATH):libinit_oneplus8pro
PRODUCT_FULL_TREBLE := false
BOARD_VNDK_VERSION := current
BOARD_VNDK_RUNTIME_DISABLE := false
TARGET_NO_KERNEL := false
BOARD_USES_VENDORIMAGE := true
TARGET_MOUNT_POINTS_SYMLINKS := true

SOONG_CONFIG_NAMESPACES += aosp_vs_qva
SOONG_CONFIG_aosp_vs_qva += aosp_or_qva
SOONG_CONFIG_aosp_vs_qva_aosp_or_qva := qva

# Split selinux policy
PRODUCT_SEPOLICY_SPLIT := true

# Android generic system image always create metadata partition
BOARD_USES_METADATA_PARTITION := true

TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_PRODUCT := product

TARGET_RECOVERY_FSTAB := $(BOARD_PATH)/recovery_dynamic_partition.fstab
BOARD_USES_FULL_RECOVERY_IMAGE := true

TARGET_NO_BOOTLOADER := true
ifeq ($(TARGET_DEVICE),oneplus8pro)
TARGET_OTA_ASSERT_DEVICE := oneplus8pro
endif
TARGET_KERNEL_VERSION := 4.19
#KERNEL_LLVM_SUPPORT := true
TARGET_KERNEL_CLANG_COMPILE := true
#TARGET_KERNEL_CLANG_VERSION := 4.0.2
#TARGET_KERNEL_CLANG_PATH := "./vendor/qcom/sdclang/8.0/prebuilt/linux-x86_64"
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

# Platform
TARGET_BOARD_PLATFORM := kona
TARGET_BOOTLOADER_BOARD_NAME := kona
TARGET_BOARD_PLATFORM_GPU := qcom-adreno650

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := kryo300

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a75


TARGET_USE_QCOM_BIONIC_OPTIMIZATION := true
TARGET_USES_64_BIT_BINDER := true
TARGET_COMPILE_WITH_MSM_KERNEL := true

BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=2048 loop.max_part=7 cgroup.memory=nokmem,nosocket reboot=panic_warm
#BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
TARGET_KERNEL_ADDITIONAL_FLAGS := DTC_EXT=$(shell pwd)/prebuilts/misc/linux-x86/dtc/dtc
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_ROOT_EXTRA_FOLDERS += op1 op2
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_KERNEL_SOURCE := kernel/oneplus/sm8250
TARGET_KERNEL_CONFIG := vendor/omni-oneplus8pro_defconfig
BOARD_KERNEL_SEPARATED_DTBO := true
TARGET_USES_UNCOMPRESSED_KERNEL := false
TARGET_KERNEL_APPEND_DTB := false
BOARD_BOOT_HEADER_VERSION := 2
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_INCLUDE_RECOVERY_DTBO := true


# partitions
BOARD_USERDATAIMAGE_PARTITION_SIZE := 19327352832
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_METADATAIMAGE_PARTITION_SIZE := 16777216
BOARD_DTBOIMG_PARTITION_SIZE := 12697600
BOARD_ODMIMAGE_PARTITION_SIZE := 67108864
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4

# global
TARGET_SPECIFIC_HEADER_PATH := $(BOARD_PATH)/include
BOARD_USES_QCOM_HARDWARE := true
TARGET_USES_QCOM_BSP := false
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

# Generic AOSP image always requires separate vendor.img
TARGET_COPY_OUT_VENDOR := vendor

# Generic AOSP image does NOT support HWC1
TARGET_USES_HWC2 := true
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
MAX_VIRTUAL_DISPLAY_DIMENSION := 4096
TARGET_USES_QCOM_DISPLAY_BSP := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USES_GRALLOC1 := true
TARGET_USES_DRM_PP := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_HAS_WIDE_COLOR_DISPLAY := true

TARGET_HAS_HDR_DISPLAY := true
TARGET_USES_DISPLAY_RENDER_INTENTS := true

VSYNC_EVENT_PHASE_OFFSET_NS := 2000000
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 6000000

#Audio
USE_XML_AUDIO_POLICY_CONF := 1
AUDIO_FEATURE_ENABLED_VOICE_CONCURRENCY := true
AUDIO_FEATURE_ENABLED_RECORD_PLAY_CONCURRENCY := true
AUDIO_FEATURE_ENABLED_EXTN_FORMATS := true
AUDIO_FEATURE_ENABLED_HDMI_SPK := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := true
AUDIO_FEATURE_ENABLED_AHAL_EXT := false
USE_CUSTOM_AUDIO_POLICY := 1

#Modules - DONT ENABLE!!
#NEED_KERNEL_MODULE_VENDOR_OVERLAY := true

# Camera
TARGET_MOTORIZED_CAMERA := false
TARGET_CAMERA_NEEDS_CLIENT_INFO := true
BOARD_USES_SNAPDRAGONCAMERA_VERSION := 2

# Disable secure discard because it's SLOW
BOARD_SUPPRESS_SECURE_ERASE := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true

#SEPERATE FROM OP6T
ifeq ($(TARGET_DEVICE),oneplus8pro)
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(BOARD_PATH)/bluetooth
endif

# Wifi
TARGET_USES_QCOM_WCNSS_QMI       := false
BOARD_HAS_QCOM_WLAN              := true
BOARD_WLAN_DEVICE                := qcwcn
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_FW_PATH_STA          := "sta"
WIFI_DRIVER_FW_PATH_AP           := "ap"
WIFI_DRIVER_FW_PATH_P2P          := "p2p"
WIFI_DRIVER_STATE_CTRL_PARAM     := "/dev/wlan"
WIFI_DRIVER_STATE_ON             := "ON"
WIFI_DRIVER_STATE_OFF            := "OFF"
WIFI_DRIVER_BUILT                := qca_cld3
WIFI_DRIVER_DEFAULT              := qca_cld3
WIFI_HIDL_FEATURE_AWARE          := true
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
QC_WIFI_HIDL_FEATURE_DUAL_AP     := true
QC_WIFI_HIDL_FEATURE_DUAL_STA    := true

# charger
HEALTHD_USE_BATTERY_INFO := true
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true

# NFC
TARGET_USES_NQ_NFC := true

# ANT+
TARGET_USES_PREBUILT_ANT := true
BOARD_ANT_WIRELESS_DEVICE := "qualcomm-hidl"

#vold
TARGET_KERNEL_HAVE_NTFS := true
TARGET_KERNEL_HAVE_EXFAT := true

# CNE and DPM
BOARD_USES_QCNE := true

ifeq ($(TARGET_DEVICE),oneplus8pro)
TARGET_SYSTEM_PROP += $(BOARD_PATH)/system.prop
endif
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# selinux
include vendor/omni/sepolicy/sepolicy.mk
include device/qcom/sepolicy/SEPolicy.mk
BOARD_PLAT_PUBLIC_SEPOLICY_DIR += $(BOARD_PATH)/sepolicy/public
BOARD_PLAT_PRIVATE_SEPOLICY_DIR += $(BOARD_PATH)/sepolicy/private
PRODUCT_PRIVATE_SEPOLICY_DIRS += $(BOARD_PATH)/sepolicy/product/priv
PRODUCT_PUBLIC_SEPOLICY_DIRS += $(BOARD_PATH)/sepolicy/product/public

# for offmode charging
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_23x41.h\"
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_QCOM_BSP := false

#gapps
TARGET_INCLUDE_STOCK_ARCORE := true


# FOD
TARGET_SURFACEFLINGER_FOD_LIB := //$(BOARD_PATH):libfod_extension.oneplus_kona

# HIDL
DEVICE_FRAMEWORK_MANIFEST_FILE += $(BOARD_PATH)/framework_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += ${BOARD_PATH}/vintf/oem.xml
DEVICE_MATRIX_FILE := $(BOARD_PATH)/vintf/compatibility_matrix.xml

USE_SENSOR_HAL_VER := 2.0

TARGET_FWK_SUPPORTS_FULL_VALUEADDS := true
TARGET_USES_QSSI_NQ_NFC := true

ifeq ($(TARGET_DEVICE),oneplus8pro)
OMNI_PRODUCT_PROPERTIES += \
    ro.sf.lcd_density=540
endif

DEXPREOPT_GENERATE_APEX_IMAGE := true

ifeq ($(TARGET_DEVICE),oneplus8pro)
ifneq ($(filter $(ROM_BUILD_RADIO), true),)
BOARD_PACK_RADIOIMAGES := abl
BOARD_PACK_RADIOIMAGES += aop
BOARD_PACK_RADIOIMAGES += bluetooth
BOARD_PACK_RADIOIMAGES += cmnlib64
BOARD_PACK_RADIOIMAGES += cmnlib
BOARD_PACK_RADIOIMAGES += devcfg
BOARD_PACK_RADIOIMAGES += dsp
BOARD_PACK_RADIOIMAGES += featenabler
BOARD_PACK_RADIOIMAGES += hyp
BOARD_PACK_RADIOIMAGES += imagefv
BOARD_PACK_RADIOIMAGES += keymaster
BOARD_PACK_RADIOIMAGES += logo
#BOARD_PACK_RADIOIMAGES += mdm_oem_stanvbk
BOARD_PACK_RADIOIMAGES += modem
BOARD_PACK_RADIOIMAGES += multiimgoem
BOARD_PACK_RADIOIMAGES += qupfw
#BOARD_PACK_RADIOIMAGES += reserve
BOARD_PACK_RADIOIMAGES += storsec
#BOARD_PACK_RADIOIMAGES += spunvm
BOARD_PACK_RADIOIMAGES += tz
BOARD_PACK_RADIOIMAGES += uefisecapp
BOARD_PACK_RADIOIMAGES += xbl_config
BOARD_PACK_RADIOIMAGES += xbl
BOARD_PACK_RADIOIMAGES += storsec
endif
endif
