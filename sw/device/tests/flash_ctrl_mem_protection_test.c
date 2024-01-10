// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/base/macros.h"
#include "sw/device/lib/base/memory.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_base.h"
#include "sw/device/lib/dif/dif_flash_ctrl.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/flash_ctrl_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "flash_ctrl_regs.h"
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

/**
 * FLASH_CTRL memory protection test
 *
 * This test checks multiple memory protection regions and priority in case
 * any regions overlap.
 *
 * Test programs regions as follows.
 *
 * region | bank | page start | page end | rd_en | prog_en | erase_en |
 * -------------------------------------------------------------------:
 * 0      | 1    | 12         | 13       | True  | False   | True     |
 * 3      | 1    | 11         | 14       | False | True    | True     |
 * 7      | 1    | 10         | 15       | True  | True    | True     |
 *
 * As you see, these regions intentionally overlap each other.
 * For any overlaping regions the lower region has priority.
 * To check this attribute, test will program higher region first.
 * Test programs Region 7, 3 and 0 in order and checks
 * write and read back based on each region's attribute.
 */
OTTF_DEFINE_TEST_CONFIG();

static dif_flash_ctrl_state_t flash;

typedef struct test {
  /**
   * Memory protection(MP) region number
   */
  uint32_t region_index;
  /**
   * Write data per each page.
   * Full size of write data per page (2KB) is generated by
   * loop:
   *   j = 0; j < words_per_page (256); j++
   *   randomdata + j
   */
  uint32_t randomdata[6];
  /**
   * Page start index per each MP region.
   */
  uint32_t page_start;
  /**
   * Write permission per each page.
   */
  bool write_permission[6];
  /**
   * Read permission per each page.
   */
  bool read_permission[6];
  /**
   * MP region config property.
   */
  dif_flash_ctrl_data_region_properties_t data_region;
} test_t;

#define BANK1_START_PAGE 256
#define START_PAGE_ADDR \
  TOP_EARLGREY_FLASH_CTRL_MEM_BASE_ADDR + FLASH_CTRL_PARAM_BYTES_PER_BANK

static const test_t kRegion[] = {
    {.region_index = 0,
     .randomdata = {0x77777770, 0x66666660},
     .page_start = 12,
     .write_permission = {false, false},
     .read_permission = {true, true},
     .data_region =
         {
             .base = BANK1_START_PAGE + 12,
             .size = 2,
             .properties =
                 {
                     .rd_en = kMultiBitBool4True,
                     .prog_en = kMultiBitBool4False,
                     .erase_en = kMultiBitBool4True,
                     .scramble_en = kMultiBitBool4True,
                     .ecc_en = kMultiBitBool4True,
                     .high_endurance_en = kMultiBitBool4False,
                 },
         }},
    {.region_index = 3,
     .randomdata = {0x88888880, 0x77777770, 0x66666660, 0x55555550},
     .page_start = 11,
     .write_permission = {true, true, true, true},
     .read_permission = {false, false, false, false},
     .data_region =
         {
             .base = BANK1_START_PAGE + 11,
             .size = 4,
             .properties =
                 {
                     .rd_en = kMultiBitBool4False,
                     .prog_en = kMultiBitBool4True,
                     .erase_en = kMultiBitBool4True,
                     .scramble_en = kMultiBitBool4True,
                     .ecc_en = kMultiBitBool4True,
                     .high_endurance_en = kMultiBitBool4False,
                 },
         }},
    {.region_index = 7,
     .randomdata = {0xaaaaaaa0, 0xbbbbbbb0, 0xccccccc0, 0xddddddd0, 0xeeeeeee0,
                    0x99999990},
     .page_start = 10,
     .write_permission = {true, true, true, true, true, true},
     .read_permission = {true, true, true, true, true, true},
     .data_region =
         {
             .base = BANK1_START_PAGE + 10,
             .size = 6,
             .properties =
                 {
                     .rd_en = kMultiBitBool4True,
                     .prog_en = kMultiBitBool4True,
                     .erase_en = kMultiBitBool4True,
                     .scramble_en = kMultiBitBool4True,
                     .ecc_en = kMultiBitBool4True,
                     .high_endurance_en = kMultiBitBool4False,
                 },
         }},
};

/**
 * Memory write and readback test
 * For each MP region, this function check write and read permission
 * based on MP region properties and priority of each MP region.
 */
static void test_mem_access(test_t region) {
  uint32_t page_size = region.data_region.size;
  uintptr_t start_epage =
      (uintptr_t)(START_PAGE_ADDR +
                  FLASH_CTRL_PARAM_BYTES_PER_PAGE * region.page_start);
  uint32_t wdata[FLASH_CTRL_PARAM_WORDS_PER_PAGE];

  for (uint32_t i = 0; i < page_size; i++) {
    for (size_t j = 0; j < ARRAYSIZE(wdata); j++)
      wdata[j] = region.randomdata[i] + j;
    if (region.write_permission[i]) {
      CHECK_STATUS_OK(flash_ctrl_testutils_erase_page(
          &flash, start_epage,
          /*partition_id=*/0, kDifFlashCtrlPartitionTypeData));
      CHECK_STATUS_OK(flash_ctrl_testutils_write(&flash, start_epage,
                                                 /*partition_id=*/0, wdata,
                                                 kDifFlashCtrlPartitionTypeData,
                                                 ARRAYSIZE(wdata)));
      LOG_INFO("test_mem_access: page %d write complete",
               region.page_start + i);
    } else {
      CHECK_STATUS_NOT_OK(flash_ctrl_testutils_write(
          &flash, start_epage,
          /*partition_id=*/0, wdata, kDifFlashCtrlPartitionTypeData,
          ARRAYSIZE(wdata)));
      LOG_INFO("test_mem_access: page %d write is not allowed",
               region.page_start + i);
    }
    uint32_t rdata[FLASH_CTRL_PARAM_WORDS_PER_PAGE];

    if (region.read_permission[i]) {
      CHECK_STATUS_OK(flash_ctrl_testutils_read(
          &flash, start_epage, /*partition_id=*/0, rdata,
          kDifFlashCtrlPartitionTypeData, ARRAYSIZE(rdata),
          /*delay=*/1));
      CHECK_ARRAYS_EQ(rdata, wdata, ARRAYSIZE(rdata));
      LOG_INFO("test_mem_access: page %d read check complete",
               region.page_start + i);
    } else {
      CHECK_STATUS_NOT_OK(flash_ctrl_testutils_read(
          &flash, start_epage, /*partition_id=*/0, rdata,
          kDifFlashCtrlPartitionTypeData, ARRAYSIZE(rdata),
          /*delay=*/1));
      LOG_INFO("test_mem_access: page %d read is not allowed",
               region.page_start + i);
    }
    start_epage += (uintptr_t)FLASH_CTRL_PARAM_BYTES_PER_PAGE;
  }
}

bool test_main(void) {
  LOG_INFO("flash mp test start!");
  CHECK_DIF_OK(dif_flash_ctrl_init_state(
      &flash, mmio_region_from_addr(TOP_EARLGREY_FLASH_CTRL_CORE_BASE_ADDR)));

  // Set up default access for data partitions.
  CHECK_STATUS_OK(flash_ctrl_testutils_default_region_access(
      &flash, /*rd_en=*/true, /*prog_en=*/true, /*erase_en=*/true,
      /*scramble_en=*/false, /*ecc_en=*/false, /*high_endurance_en=*/false));

  // Program starts from kRegion[2], kRegion[1], and kRegion[0] in order.
  for (int i = 2; i >= 0; i--) {
    CHECK_DIF_OK(dif_flash_ctrl_set_data_region_properties(
        &flash, kRegion[i].region_index, kRegion[i].data_region));
    CHECK_DIF_OK(dif_flash_ctrl_set_data_region_enablement(
        &flash, kRegion[i].region_index, kDifToggleEnabled));
    test_mem_access(kRegion[i]);
  }

  LOG_INFO("test done");
  return true;
}
