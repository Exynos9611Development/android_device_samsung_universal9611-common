## Filesystem config - Dynamic
BOARD_SUPER_PARTITION_SIZE := 6836715520
BOARD_SUPER_PARTITION_GROUPS := samsung_dynamic_partitions
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_SIZE := 6832521216 # SUPER_SIZE - 4MB
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_PARTITION_LIST := \
        system \
        product \
        vendor \
        odm

TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_ODM := odm

ifneq ($(wildcard vendor/gms),)
$(warning Assuming WITH_GMS is true)
WITH_GMS ?= true
endif

# Reserved sizes
-include vendor/lineage/config/BoardConfigReservedSize.mk

# File system type
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
