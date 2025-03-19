#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_vendorcompat,
    lib_fixups_user_type,
    libs_proto_3_9_1,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/samsung/universal9611-common',
    'hardware/samsung',
    'hardware/samsung_slsi-linaro/graphics',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

def lib_fixup_device_dep(lib: str, partition: str, *args, **kwargs):
    return f'//device/samsung/universal9611-common/shims/stub:{lib}'

lib_fixups: lib_fixups_user_type = {
    libs_proto_3_9_1: lib_fixup_vendorcompat,
    'libsecnativefeature': lib_fixup_device_dep,
    'libuuid': lib_fixup_vendor_suffix,
} # fmt: skip

blob_fixups: blob_fixups_user_type = {
    (
        'vendor/bin/vaultkeeperd',
        'vendor/lib64/libvkservice.so',
    ): blob_fixup()
        .binary_regex_replace(b'ro.factory.factory_binary', b'ro.vendor.factory_binary\x00'),
    'vendor/lib/libwvhidl.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    (
        'vendor/lib64/hw/android.hardware.gnss@2.1-impl.so',
        'vendor/lib64/hw/vendor.samsung.hardware.gnss@2.0-impl.so',
    ): blob_fixup()
        .remove_needed('libhidltransport.so'),
    'vendor/lib64/libssl-tm.so': blob_fixup()
        .replace_needed('libcrypto.so', 'libcrypto-tm.so'),
    'vendor/lib64/libsec-ril.so': blob_fixup()
        .sig_replace('80 0E 40 F9 E1 03 16 AA 82 0C 80 52 E3 03 15 AA',
            '80 0E 40 F9 E1 03 16 AA 82 0C 80 52 08 00 80 D2'),
    'vendor/lib64/libvkservice.so': blob_fixup()
        .binary_regex_replace(b'ro.factory.factory_binary', b'ro.vendor.factory_binary\x00'),
    (
        'vendor/lib64/libkeymaster_helper.so',
        'vendor/lib64/libskeymaster4device.so',
    ) : blob_fixup()
        .replace_needed('libcrypto.so', 'libcrypto-tm.so')
        .add_needed('libshim_crypto.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'universal9611-common',
    'samsung',
    namespace_imports=namespace_imports,
    lib_fixups=lib_fixups,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
