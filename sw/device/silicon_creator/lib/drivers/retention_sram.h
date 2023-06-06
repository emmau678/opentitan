// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_DRIVERS_RETENTION_SRAM_H_
#define OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_DRIVERS_RETENTION_SRAM_H_

#include "sw/device/lib/base/macros.h"
#include "sw/device/silicon_creator/lib/error.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Retention SRAM silicon creator area.
 */
typedef struct retention_sram_creator {
  /**
   * Reset reasons reported by the reset manager before they were reset in mask
   * ROM.
   */
  uint32_t reset_reasons;
  /**
   * Space reserved for future allocation by the silicon creator.
   */
  uint32_t reserved[2048 / sizeof(uint32_t) - 2];
} retention_sram_creator_t;
OT_ASSERT_SIZE(retention_sram_creator_t, 2044);

/**
 * Retention SRAM silicon owner area.
 */
typedef struct retention_sram_owner {
  /**
   * Space reserved for allocation by the silicon owner.
   *
   * The silcon creator boot stages will not modify this field except for
   * clearing it at initial power on.
   *
   * Tests that need to trigger (or detect) a device reset may use this field to
   * preserve state information across resets.
   */
  uint32_t reserved[2048 / sizeof(uint32_t)];
} retention_sram_owner_t;
OT_ASSERT_SIZE(retention_sram_owner_t, 2048);

/**
 * The retention SRAM is memory that is used to retain information, such as a
 * boot service request, across a device reset. If the reset reason is 'power
 * on' (POR) all fields will be initialized using the LFSR by the ROM.
 */
typedef struct retention_sram {
  /**
   * Retention SRAM format version.
   *
   * ROM sets this field to `kRetentionSramVersion1` only after PoR and
   * does not modify it otherwise. ROM_EXT can use this information for backward
   * compatibility and set this field to a different value after migrating to a
   * different layout if needed.
   */
  uint32_t version;
  /**
   * Silicon creator area.
   */
  retention_sram_creator_t creator;
  /**
   * Silicon owner area.
   */
  retention_sram_owner_t owner;
} retention_sram_t;

OT_ASSERT_MEMBER_OFFSET(retention_sram_t, creator, 4);
OT_ASSERT_MEMBER_OFFSET(retention_sram_t, owner, 2048);
OT_ASSERT_SIZE(retention_sram_t, 4096);

enum {
  kRetentionSramVersion1 = 0x72f4eb2e,
};

/**
 * Returns a typed pointer to the retention SRAM.
 *
 * @return A pointer to the retention SRAM.
 */
OT_WARN_UNUSED_RESULT
retention_sram_t *retention_sram_get(void);

/**
 * Clear the retention SRAM by setting every word to 0.
 */
void retention_sram_clear(void);

/**
 * Initialize the retention SRAM with pseudo-random data from the LFSR.
 *
 * This function does not request a new scrambling key. See
 * `retention_sram_scramble()`.
 *
 * @return Result of the operation.
 */
void retention_sram_init(void);

/**
 * Start scrambling the retention SRAM.
 *
 * Requests a new scrambling key for the retention SRAM. This operation
 * will wipe all of the data in the retention SRAM. The retention SRAM
 * will then be initialized to undefined values.
 *
 * The scrambling operation takes time and accesses to retention SRAM
 * will stall until it completes.
 *
 * @return An error if a new key cannot be requested.
 */
void retention_sram_scramble(void);

#ifdef __cplusplus
}
#endif

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_DRIVERS_RETENTION_SRAM_H_
