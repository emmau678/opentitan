// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//! Structs for reading and writing manifests of flash boot stage images.
//!
//! Note: The structs below must match the definitions in
//! sw/device/silicon_creator/lib/manifest.h.

#![deny(warnings)]
#![deny(unused)]
#![deny(unsafe_code)]

use zerocopy::AsBytes;
use zerocopy::FromBytes;

// Currently, these definitions must be updated manually but they can be
// generated using the following commands (requires bindgen):
//   cargo install bindgen
//   cd "${REPO_TOP}"
//   bindgen --allowlist-type manifest_t --allowlist-var "MANIFEST_.*" \
//      --allowlist-var "CHIP_.*" \
//      --no-doc-comments --no-layout-tests \
//      sw/device/silicon_creator/lib/manifest.h \
//      sw/device/silicon_creator/lib/base/chip.h \
//      -- -I./ -Isw/device/lib/base/freestanding
// TODO: Generate some constants as hex if possible, replacing manually for now.

pub const CHIP_MANIFEST_SIZE: u32 = 964;
pub const CHIP_MANIFEST_EXT_TABLE_COUNT: u32 = 8;
pub const MANIFEST_USAGE_CONSTRAINT_UNSELECTED_WORD_VAL: u32 = 0xa5a5a5a5;
pub const CHIP_ROM_EXT_IDENTIFIER: u32 = 0x4552544f;
pub const CHIP_BL0_IDENTIFIER: u32 = 0x3042544f;
pub const CHIP_ROM_EXT_SIZE_MIN: u32 = 8788;
pub const CHIP_ROM_EXT_SIZE_MAX: u32 = 0x10000;
pub const CHIP_BL0_SIZE_MIN: u32 = 8788;
pub const CHIP_BL0_SIZE_MAX: u32 = 0x70000;

/// Manifest for boot stage images stored in flash.
#[repr(C)]
#[derive(FromBytes, AsBytes, Debug, Default)]
pub struct Manifest {
    pub rsa_signature: SigverifyRsaBuffer,
    pub usage_constraints: ManifestUsageConstraints,
    pub rsa_modulus: SigverifyRsaBuffer,
    pub address_translation: u32,
    pub identifier: u32,
    pub signed_region_end: u32,
    pub length: u32,
    pub version_major: u32,
    pub version_minor: u32,
    pub security_version: u32,
    pub timestamp: Timestamp,
    pub binding_value: KeymgrBindingValue,
    pub max_key_version: u32,
    pub code_start: u32,
    pub code_end: u32,
    pub entry_point: u32,
    pub extensions: ManifestExtTable,
}

/// A type that holds 1964 32-bit words for SPHINCS+ signtures.
#[repr(C)]
#[derive(FromBytes, AsBytes, Debug)]
pub struct SigverifySpxSignature {
    pub data: [u32; 1964usize],
}

impl Default for SigverifySpxSignature {
    fn default() -> Self {
        Self {
            data: [0; 1964usize],
        }
    }
}

/// Extension header.
#[repr(C)]
#[derive(FromBytes, AsBytes, Debug, Default)]
pub struct ManifestExtHeader {
    pub identifier: u32,
    pub name: u32,
}

/// SPHINCS+ signature manifest extension.
#[repr(C)]
#[derive(FromBytes, AsBytes, Debug, Default)]
pub struct ManifestExtSpxSignature {
    pub header: ManifestExtHeader,
    pub signature: SigverifySpxSignature,
}

/// A type that holds 8 32-bit words for SPHINCS+ public keys.
#[repr(C)]
#[derive(FromBytes, AsBytes, Debug, Default)]
pub struct SigverifySpxKey {
    pub data: [u32; 8usize],
}

/// SPHINCS+ public key manifest extension.
#[repr(C)]
#[derive(FromBytes, AsBytes, Debug, Default)]
pub struct ManifestExtSpxKey {
    pub header: ManifestExtHeader,
    pub key: SigverifySpxKey,
}

/// A type that holds 96 32-bit words for RSA-3072.
#[repr(C)]
#[derive(FromBytes, AsBytes, Debug)]
pub struct SigverifyRsaBuffer {
    pub data: [u32; 96usize],
}

impl Default for SigverifyRsaBuffer {
    fn default() -> Self {
        Self { data: [0; 96usize] }
    }
}

/// A type that holds the 256-bit device identifier.
#[repr(C)]
#[derive(FromBytes, AsBytes, Debug, Default)]
pub struct LifecycleDeviceId {
    pub device_id: [u32; 8usize],
}

/// Manifest usage constraints.
#[repr(C)]
#[derive(FromBytes, AsBytes, Debug)]
pub struct ManifestUsageConstraints {
    pub selector_bits: u32,
    pub device_id: LifecycleDeviceId,
    pub manuf_state_creator: u32,
    pub manuf_state_owner: u32,
    pub life_cycle_state: u32,
}

impl Default for ManifestUsageConstraints {
    fn default() -> Self {
        Self {
            selector_bits: 0,
            device_id: LifecycleDeviceId {
                device_id: [MANIFEST_USAGE_CONSTRAINT_UNSELECTED_WORD_VAL; 8usize],
            },
            manuf_state_creator: MANIFEST_USAGE_CONSTRAINT_UNSELECTED_WORD_VAL,
            manuf_state_owner: MANIFEST_USAGE_CONSTRAINT_UNSELECTED_WORD_VAL,
            life_cycle_state: MANIFEST_USAGE_CONSTRAINT_UNSELECTED_WORD_VAL,
        }
    }
}

/// Manifest timestamp
#[repr(C)]
#[derive(FromBytes, AsBytes, Debug, Default)]
pub struct Timestamp {
    pub data: [u32; 2usize],
}

#[repr(C)]
#[derive(FromBytes, AsBytes, Debug, Default)]
pub struct KeymgrBindingValue {
    pub data: [u32; 8usize],
}

#[repr(C)]
#[derive(FromBytes, AsBytes, Debug, Default, Copy, Clone)]
pub struct ManifestExtTableEntry {
    pub identifier: u32,
    pub offset: u32,
}

#[repr(C)]
#[derive(FromBytes, AsBytes, Debug, Default, Copy, Clone)]
pub struct ManifestExtTable {
    pub entries: [ManifestExtTableEntry; CHIP_MANIFEST_EXT_TABLE_COUNT as usize],
}

#[cfg(test)]
mod tests {
    use super::*;
    use memoffset::offset_of;
    use std::mem::size_of;

    /// Checks the layout of the manifest struct.
    ///
    /// Implemented as a function because using `offset_of!` at compile-time
    /// requires a nightly compiler.
    #[test]
    pub fn test_manifest_layout() {
        assert_eq!(offset_of!(Manifest, rsa_signature), 0);
        assert_eq!(offset_of!(Manifest, usage_constraints), 384);
        assert_eq!(offset_of!(Manifest, rsa_modulus), 432);
        assert_eq!(offset_of!(Manifest, address_translation), 816);
        assert_eq!(offset_of!(Manifest, identifier), 820);
        assert_eq!(offset_of!(Manifest, signed_region_end), 824);
        assert_eq!(offset_of!(Manifest, length), 828);
        assert_eq!(offset_of!(Manifest, version_major), 832);
        assert_eq!(offset_of!(Manifest, version_minor), 836);
        assert_eq!(offset_of!(Manifest, security_version), 840);
        assert_eq!(offset_of!(Manifest, timestamp), 844);
        assert_eq!(offset_of!(Manifest, binding_value), 852);
        assert_eq!(offset_of!(Manifest, max_key_version), 884);
        assert_eq!(offset_of!(Manifest, code_start), 888);
        assert_eq!(offset_of!(Manifest, code_end), 892);
        assert_eq!(offset_of!(Manifest, entry_point), 896);
        assert_eq!(offset_of!(Manifest, extensions), 900);
        assert_eq!(size_of::<Manifest>(), CHIP_MANIFEST_SIZE as usize);
    }
}
