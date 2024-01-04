// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package spi_device_reg_pkg;

  // Param list
  parameter int unsigned SramDepth = 1024;
  parameter int unsigned SramEgressDepth = 832;
  parameter int unsigned SramIngressDepth = 96;
  parameter int unsigned NumCmdInfo = 24;
  parameter int unsigned NumLocality = 5;
  parameter int unsigned TpmWrFifoPtrW = 7;
  parameter int unsigned TpmRdFifoPtrW = 5;
  parameter int unsigned TpmRdFifoWidth = 32;
  parameter int NumAlerts = 1;

  // Address widths within the block
  parameter int BlockAw = 13;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } upload_cmdfifo_not_empty;
    struct packed {
      logic        q;
    } upload_payload_not_empty;
    struct packed {
      logic        q;
    } upload_payload_overflow;
    struct packed {
      logic        q;
    } readbuf_watermark;
    struct packed {
      logic        q;
    } readbuf_flip;
    struct packed {
      logic        q;
    } tpm_header_not_empty;
  } spi_device_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } upload_cmdfifo_not_empty;
    struct packed {
      logic        q;
    } upload_payload_not_empty;
    struct packed {
      logic        q;
    } upload_payload_overflow;
    struct packed {
      logic        q;
    } readbuf_watermark;
    struct packed {
      logic        q;
    } readbuf_flip;
    struct packed {
      logic        q;
    } tpm_header_not_empty;
  } spi_device_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } upload_cmdfifo_not_empty;
    struct packed {
      logic        q;
      logic        qe;
    } upload_payload_not_empty;
    struct packed {
      logic        q;
      logic        qe;
    } upload_payload_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } readbuf_watermark;
    struct packed {
      logic        q;
      logic        qe;
    } readbuf_flip;
    struct packed {
      logic        q;
      logic        qe;
    } tpm_header_not_empty;
  } spi_device_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } spi_device_reg2hw_alert_test_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } spi_device_reg2hw_control_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } cpol;
    struct packed {
      logic        q;
    } cpha;
    struct packed {
      logic        q;
    } tx_order;
    struct packed {
      logic        q;
    } rx_order;
    struct packed {
      logic        q;
    } addr_4b_en;
    struct packed {
      logic        q;
    } mailbox_en;
  } spi_device_reg2hw_cfg_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } status;
    struct packed {
      logic        q;
    } jedec;
    struct packed {
      logic        q;
    } sfdp;
    struct packed {
      logic        q;
    } mbx;
  } spi_device_reg2hw_intercept_en_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } busy;
    struct packed {
      logic [22:0] q;
      logic        qe;
    } status;
  } spi_device_reg2hw_flash_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  q;
    } cc;
    struct packed {
      logic [7:0]  q;
    } num_cc;
  } spi_device_reg2hw_jedec_cc_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } id;
    struct packed {
      logic [7:0]  q;
    } mf;
  } spi_device_reg2hw_jedec_id_reg_t;

  typedef struct packed {
    logic [9:0] q;
  } spi_device_reg2hw_read_threshold_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } spi_device_reg2hw_mailbox_addr_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        re;
  } spi_device_reg2hw_upload_cmdfifo_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        re;
  } spi_device_reg2hw_upload_addrfifo_reg_t;

  typedef struct packed {
    logic        q;
  } spi_device_reg2hw_cmd_filter_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } spi_device_reg2hw_addr_swap_mask_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } spi_device_reg2hw_addr_swap_data_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } spi_device_reg2hw_payload_swap_mask_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } spi_device_reg2hw_payload_swap_data_reg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  q;
    } opcode;
    struct packed {
      logic [1:0]  q;
    } addr_mode;
    struct packed {
      logic        q;
    } addr_swap_en;
    struct packed {
      logic        q;
    } mbyte_en;
    struct packed {
      logic [2:0]  q;
    } dummy_size;
    struct packed {
      logic        q;
    } dummy_en;
    struct packed {
      logic [3:0]  q;
    } payload_en;
    struct packed {
      logic        q;
    } payload_dir;
    struct packed {
      logic        q;
    } payload_swap_en;
    struct packed {
      logic        q;
    } upload;
    struct packed {
      logic        q;
    } busy;
    struct packed {
      logic        q;
    } valid;
  } spi_device_reg2hw_cmd_info_mreg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  q;
    } opcode;
    struct packed {
      logic        q;
    } valid;
  } spi_device_reg2hw_cmd_info_en4b_reg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  q;
    } opcode;
    struct packed {
      logic        q;
    } valid;
  } spi_device_reg2hw_cmd_info_ex4b_reg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  q;
    } opcode;
    struct packed {
      logic        q;
    } valid;
  } spi_device_reg2hw_cmd_info_wren_reg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  q;
    } opcode;
    struct packed {
      logic        q;
    } valid;
  } spi_device_reg2hw_cmd_info_wrdi_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic        q;
    } tpm_mode;
    struct packed {
      logic        q;
    } hw_reg_dis;
    struct packed {
      logic        q;
    } tpm_reg_chk_dis;
    struct packed {
      logic        q;
    } invalid_locality;
  } spi_device_reg2hw_tpm_cfg_reg_t;

  typedef struct packed {
    logic [7:0]  q;
  } spi_device_reg2hw_tpm_access_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } spi_device_reg2hw_tpm_sts_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } spi_device_reg2hw_tpm_intf_capability_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } spi_device_reg2hw_tpm_int_enable_reg_t;

  typedef struct packed {
    logic [7:0]  q;
  } spi_device_reg2hw_tpm_int_vector_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } spi_device_reg2hw_tpm_int_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } vid;
    struct packed {
      logic [15:0] q;
    } did;
  } spi_device_reg2hw_tpm_did_vid_reg_t;

  typedef struct packed {
    logic [7:0]  q;
  } spi_device_reg2hw_tpm_rid_reg_t;

  typedef struct packed {
    struct packed {
      logic [23:0] q;
      logic        qe;
      logic        re;
    } addr;
    struct packed {
      logic [7:0]  q;
      logic        qe;
      logic        re;
    } cmd;
  } spi_device_reg2hw_tpm_cmd_addr_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } spi_device_reg2hw_tpm_read_fifo_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        qe;
    logic        re;
  } spi_device_reg2hw_tpm_write_fifo_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } upload_cmdfifo_not_empty;
    struct packed {
      logic        d;
      logic        de;
    } upload_payload_not_empty;
    struct packed {
      logic        d;
      logic        de;
    } upload_payload_overflow;
    struct packed {
      logic        d;
      logic        de;
    } readbuf_watermark;
    struct packed {
      logic        d;
      logic        de;
    } readbuf_flip;
    struct packed {
      logic        d;
      logic        de;
    } tpm_header_not_empty;
  } spi_device_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } addr_4b_en;
  } spi_device_hw2reg_cfg_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } csb;
    struct packed {
      logic        d;
    } tpm_csb;
  } spi_device_hw2reg_status_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } spi_device_hw2reg_last_read_addr_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } busy;
    struct packed {
      logic [22:0] d;
    } status;
  } spi_device_hw2reg_flash_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [4:0]  d;
      logic        de;
    } cmdfifo_depth;
    struct packed {
      logic        d;
      logic        de;
    } cmdfifo_notempty;
    struct packed {
      logic [4:0]  d;
      logic        de;
    } addrfifo_depth;
    struct packed {
      logic        d;
      logic        de;
    } addrfifo_notempty;
  } spi_device_hw2reg_upload_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [8:0]  d;
      logic        de;
    } payload_depth;
    struct packed {
      logic [7:0]  d;
      logic        de;
    } payload_start_idx;
  } spi_device_hw2reg_upload_status2_reg_t;

  typedef struct packed {
    logic [7:0]  d;
  } spi_device_hw2reg_upload_cmdfifo_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } spi_device_hw2reg_upload_addrfifo_reg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  d;
      logic        de;
    } rev;
    struct packed {
      logic        d;
      logic        de;
    } locality;
    struct packed {
      logic [2:0]  d;
      logic        de;
    } max_wr_size;
    struct packed {
      logic [2:0]  d;
      logic        de;
    } max_rd_size;
  } spi_device_hw2reg_tpm_cap_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } cmdaddr_notempty;
    struct packed {
      logic [6:0]  d;
      logic        de;
    } wrfifo_depth;
  } spi_device_hw2reg_tpm_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [23:0] d;
    } addr;
    struct packed {
      logic [7:0]  d;
    } cmd;
  } spi_device_hw2reg_tpm_cmd_addr_reg_t;

  typedef struct packed {
    logic [7:0]  d;
  } spi_device_hw2reg_tpm_write_fifo_reg_t;

  // Register -> HW type
  typedef struct packed {
    spi_device_reg2hw_intr_state_reg_t intr_state; // [1507:1502]
    spi_device_reg2hw_intr_enable_reg_t intr_enable; // [1501:1496]
    spi_device_reg2hw_intr_test_reg_t intr_test; // [1495:1484]
    spi_device_reg2hw_alert_test_reg_t alert_test; // [1483:1482]
    spi_device_reg2hw_control_reg_t control; // [1481:1480]
    spi_device_reg2hw_cfg_reg_t cfg; // [1479:1474]
    spi_device_reg2hw_intercept_en_reg_t intercept_en; // [1473:1470]
    spi_device_reg2hw_flash_status_reg_t flash_status; // [1469:1444]
    spi_device_reg2hw_jedec_cc_reg_t jedec_cc; // [1443:1428]
    spi_device_reg2hw_jedec_id_reg_t jedec_id; // [1427:1404]
    spi_device_reg2hw_read_threshold_reg_t read_threshold; // [1403:1394]
    spi_device_reg2hw_mailbox_addr_reg_t mailbox_addr; // [1393:1362]
    spi_device_reg2hw_upload_cmdfifo_reg_t upload_cmdfifo; // [1361:1353]
    spi_device_reg2hw_upload_addrfifo_reg_t upload_addrfifo; // [1352:1320]
    spi_device_reg2hw_cmd_filter_mreg_t [255:0] cmd_filter; // [1319:1064]
    spi_device_reg2hw_addr_swap_mask_reg_t addr_swap_mask; // [1063:1032]
    spi_device_reg2hw_addr_swap_data_reg_t addr_swap_data; // [1031:1000]
    spi_device_reg2hw_payload_swap_mask_reg_t payload_swap_mask; // [999:968]
    spi_device_reg2hw_payload_swap_data_reg_t payload_swap_data; // [967:936]
    spi_device_reg2hw_cmd_info_mreg_t [23:0] cmd_info; // [935:336]
    spi_device_reg2hw_cmd_info_en4b_reg_t cmd_info_en4b; // [335:327]
    spi_device_reg2hw_cmd_info_ex4b_reg_t cmd_info_ex4b; // [326:318]
    spi_device_reg2hw_cmd_info_wren_reg_t cmd_info_wren; // [317:309]
    spi_device_reg2hw_cmd_info_wrdi_reg_t cmd_info_wrdi; // [308:300]
    spi_device_reg2hw_tpm_cfg_reg_t tpm_cfg; // [299:295]
    spi_device_reg2hw_tpm_access_mreg_t [4:0] tpm_access; // [294:255]
    spi_device_reg2hw_tpm_sts_reg_t tpm_sts; // [254:223]
    spi_device_reg2hw_tpm_intf_capability_reg_t tpm_intf_capability; // [222:191]
    spi_device_reg2hw_tpm_int_enable_reg_t tpm_int_enable; // [190:159]
    spi_device_reg2hw_tpm_int_vector_reg_t tpm_int_vector; // [158:151]
    spi_device_reg2hw_tpm_int_status_reg_t tpm_int_status; // [150:119]
    spi_device_reg2hw_tpm_did_vid_reg_t tpm_did_vid; // [118:87]
    spi_device_reg2hw_tpm_rid_reg_t tpm_rid; // [86:79]
    spi_device_reg2hw_tpm_cmd_addr_reg_t tpm_cmd_addr; // [78:43]
    spi_device_reg2hw_tpm_read_fifo_reg_t tpm_read_fifo; // [42:10]
    spi_device_reg2hw_tpm_write_fifo_reg_t tpm_write_fifo; // [9:0]
  } spi_device_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    spi_device_hw2reg_intr_state_reg_t intr_state; // [215:204]
    spi_device_hw2reg_cfg_reg_t cfg; // [203:202]
    spi_device_hw2reg_status_reg_t status; // [201:200]
    spi_device_hw2reg_last_read_addr_reg_t last_read_addr; // [199:168]
    spi_device_hw2reg_flash_status_reg_t flash_status; // [167:144]
    spi_device_hw2reg_upload_status_reg_t upload_status; // [143:128]
    spi_device_hw2reg_upload_status2_reg_t upload_status2; // [127:109]
    spi_device_hw2reg_upload_cmdfifo_reg_t upload_cmdfifo; // [108:101]
    spi_device_hw2reg_upload_addrfifo_reg_t upload_addrfifo; // [100:69]
    spi_device_hw2reg_tpm_cap_reg_t tpm_cap; // [68:50]
    spi_device_hw2reg_tpm_status_reg_t tpm_status; // [49:40]
    spi_device_hw2reg_tpm_cmd_addr_reg_t tpm_cmd_addr; // [39:8]
    spi_device_hw2reg_tpm_write_fifo_reg_t tpm_write_fifo; // [7:0]
  } spi_device_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] SPI_DEVICE_INTR_STATE_OFFSET = 13'h 0;
  parameter logic [BlockAw-1:0] SPI_DEVICE_INTR_ENABLE_OFFSET = 13'h 4;
  parameter logic [BlockAw-1:0] SPI_DEVICE_INTR_TEST_OFFSET = 13'h 8;
  parameter logic [BlockAw-1:0] SPI_DEVICE_ALERT_TEST_OFFSET = 13'h c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CONTROL_OFFSET = 13'h 10;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CFG_OFFSET = 13'h 14;
  parameter logic [BlockAw-1:0] SPI_DEVICE_STATUS_OFFSET = 13'h 18;
  parameter logic [BlockAw-1:0] SPI_DEVICE_INTERCEPT_EN_OFFSET = 13'h 1c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_LAST_READ_ADDR_OFFSET = 13'h 20;
  parameter logic [BlockAw-1:0] SPI_DEVICE_FLASH_STATUS_OFFSET = 13'h 24;
  parameter logic [BlockAw-1:0] SPI_DEVICE_JEDEC_CC_OFFSET = 13'h 28;
  parameter logic [BlockAw-1:0] SPI_DEVICE_JEDEC_ID_OFFSET = 13'h 2c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_READ_THRESHOLD_OFFSET = 13'h 30;
  parameter logic [BlockAw-1:0] SPI_DEVICE_MAILBOX_ADDR_OFFSET = 13'h 34;
  parameter logic [BlockAw-1:0] SPI_DEVICE_UPLOAD_STATUS_OFFSET = 13'h 38;
  parameter logic [BlockAw-1:0] SPI_DEVICE_UPLOAD_STATUS2_OFFSET = 13'h 3c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_UPLOAD_CMDFIFO_OFFSET = 13'h 40;
  parameter logic [BlockAw-1:0] SPI_DEVICE_UPLOAD_ADDRFIFO_OFFSET = 13'h 44;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_FILTER_0_OFFSET = 13'h 48;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_FILTER_1_OFFSET = 13'h 4c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_FILTER_2_OFFSET = 13'h 50;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_FILTER_3_OFFSET = 13'h 54;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_FILTER_4_OFFSET = 13'h 58;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_FILTER_5_OFFSET = 13'h 5c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_FILTER_6_OFFSET = 13'h 60;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_FILTER_7_OFFSET = 13'h 64;
  parameter logic [BlockAw-1:0] SPI_DEVICE_ADDR_SWAP_MASK_OFFSET = 13'h 68;
  parameter logic [BlockAw-1:0] SPI_DEVICE_ADDR_SWAP_DATA_OFFSET = 13'h 6c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_PAYLOAD_SWAP_MASK_OFFSET = 13'h 70;
  parameter logic [BlockAw-1:0] SPI_DEVICE_PAYLOAD_SWAP_DATA_OFFSET = 13'h 74;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_0_OFFSET = 13'h 78;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_1_OFFSET = 13'h 7c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_2_OFFSET = 13'h 80;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_3_OFFSET = 13'h 84;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_4_OFFSET = 13'h 88;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_5_OFFSET = 13'h 8c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_6_OFFSET = 13'h 90;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_7_OFFSET = 13'h 94;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_8_OFFSET = 13'h 98;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_9_OFFSET = 13'h 9c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_10_OFFSET = 13'h a0;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_11_OFFSET = 13'h a4;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_12_OFFSET = 13'h a8;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_13_OFFSET = 13'h ac;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_14_OFFSET = 13'h b0;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_15_OFFSET = 13'h b4;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_16_OFFSET = 13'h b8;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_17_OFFSET = 13'h bc;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_18_OFFSET = 13'h c0;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_19_OFFSET = 13'h c4;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_20_OFFSET = 13'h c8;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_21_OFFSET = 13'h cc;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_22_OFFSET = 13'h d0;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_23_OFFSET = 13'h d4;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_EN4B_OFFSET = 13'h d8;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_EX4B_OFFSET = 13'h dc;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_WREN_OFFSET = 13'h e0;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CMD_INFO_WRDI_OFFSET = 13'h e4;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_CAP_OFFSET = 13'h 800;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_CFG_OFFSET = 13'h 804;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_STATUS_OFFSET = 13'h 808;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_ACCESS_0_OFFSET = 13'h 80c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_ACCESS_1_OFFSET = 13'h 810;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_STS_OFFSET = 13'h 814;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_INTF_CAPABILITY_OFFSET = 13'h 818;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_INT_ENABLE_OFFSET = 13'h 81c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_INT_VECTOR_OFFSET = 13'h 820;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_INT_STATUS_OFFSET = 13'h 824;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_DID_VID_OFFSET = 13'h 828;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_RID_OFFSET = 13'h 82c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_CMD_ADDR_OFFSET = 13'h 830;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_READ_FIFO_OFFSET = 13'h 834;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TPM_WRITE_FIFO_OFFSET = 13'h 838;

  // Reset values for hwext registers and their fields
  parameter logic [5:0] SPI_DEVICE_INTR_TEST_RESVAL = 6'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_UPLOAD_CMDFIFO_NOT_EMPTY_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_UPLOAD_PAYLOAD_NOT_EMPTY_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_UPLOAD_PAYLOAD_OVERFLOW_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_READBUF_WATERMARK_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_READBUF_FLIP_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_TPM_HEADER_NOT_EMPTY_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_ALERT_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;
  parameter logic [6:0] SPI_DEVICE_STATUS_RESVAL = 7'h 60;
  parameter logic [0:0] SPI_DEVICE_STATUS_CSB_RESVAL = 1'h 1;
  parameter logic [0:0] SPI_DEVICE_STATUS_TPM_CSB_RESVAL = 1'h 1;
  parameter logic [31:0] SPI_DEVICE_LAST_READ_ADDR_RESVAL = 32'h 0;
  parameter logic [23:0] SPI_DEVICE_FLASH_STATUS_RESVAL = 24'h 0;
  parameter logic [7:0] SPI_DEVICE_UPLOAD_CMDFIFO_RESVAL = 8'h 0;
  parameter logic [31:0] SPI_DEVICE_UPLOAD_ADDRFIFO_RESVAL = 32'h 0;
  parameter logic [31:0] SPI_DEVICE_TPM_CMD_ADDR_RESVAL = 32'h 0;
  parameter logic [31:0] SPI_DEVICE_TPM_READ_FIFO_RESVAL = 32'h 0;
  parameter logic [7:0] SPI_DEVICE_TPM_WRITE_FIFO_RESVAL = 8'h 0;

  // Window parameters
  parameter logic [BlockAw-1:0] SPI_DEVICE_EGRESS_BUFFER_OFFSET = 13'h 1000;
  parameter int unsigned        SPI_DEVICE_EGRESS_BUFFER_SIZE   = 'h d00;
  parameter int unsigned        SPI_DEVICE_EGRESS_BUFFER_IDX    = 0;
  parameter logic [BlockAw-1:0] SPI_DEVICE_INGRESS_BUFFER_OFFSET = 13'h 1e00;
  parameter int unsigned        SPI_DEVICE_INGRESS_BUFFER_SIZE   = 'h 180;
  parameter int unsigned        SPI_DEVICE_INGRESS_BUFFER_IDX    = 1;

  // Register index
  typedef enum int {
    SPI_DEVICE_INTR_STATE,
    SPI_DEVICE_INTR_ENABLE,
    SPI_DEVICE_INTR_TEST,
    SPI_DEVICE_ALERT_TEST,
    SPI_DEVICE_CONTROL,
    SPI_DEVICE_CFG,
    SPI_DEVICE_STATUS,
    SPI_DEVICE_INTERCEPT_EN,
    SPI_DEVICE_LAST_READ_ADDR,
    SPI_DEVICE_FLASH_STATUS,
    SPI_DEVICE_JEDEC_CC,
    SPI_DEVICE_JEDEC_ID,
    SPI_DEVICE_READ_THRESHOLD,
    SPI_DEVICE_MAILBOX_ADDR,
    SPI_DEVICE_UPLOAD_STATUS,
    SPI_DEVICE_UPLOAD_STATUS2,
    SPI_DEVICE_UPLOAD_CMDFIFO,
    SPI_DEVICE_UPLOAD_ADDRFIFO,
    SPI_DEVICE_CMD_FILTER_0,
    SPI_DEVICE_CMD_FILTER_1,
    SPI_DEVICE_CMD_FILTER_2,
    SPI_DEVICE_CMD_FILTER_3,
    SPI_DEVICE_CMD_FILTER_4,
    SPI_DEVICE_CMD_FILTER_5,
    SPI_DEVICE_CMD_FILTER_6,
    SPI_DEVICE_CMD_FILTER_7,
    SPI_DEVICE_ADDR_SWAP_MASK,
    SPI_DEVICE_ADDR_SWAP_DATA,
    SPI_DEVICE_PAYLOAD_SWAP_MASK,
    SPI_DEVICE_PAYLOAD_SWAP_DATA,
    SPI_DEVICE_CMD_INFO_0,
    SPI_DEVICE_CMD_INFO_1,
    SPI_DEVICE_CMD_INFO_2,
    SPI_DEVICE_CMD_INFO_3,
    SPI_DEVICE_CMD_INFO_4,
    SPI_DEVICE_CMD_INFO_5,
    SPI_DEVICE_CMD_INFO_6,
    SPI_DEVICE_CMD_INFO_7,
    SPI_DEVICE_CMD_INFO_8,
    SPI_DEVICE_CMD_INFO_9,
    SPI_DEVICE_CMD_INFO_10,
    SPI_DEVICE_CMD_INFO_11,
    SPI_DEVICE_CMD_INFO_12,
    SPI_DEVICE_CMD_INFO_13,
    SPI_DEVICE_CMD_INFO_14,
    SPI_DEVICE_CMD_INFO_15,
    SPI_DEVICE_CMD_INFO_16,
    SPI_DEVICE_CMD_INFO_17,
    SPI_DEVICE_CMD_INFO_18,
    SPI_DEVICE_CMD_INFO_19,
    SPI_DEVICE_CMD_INFO_20,
    SPI_DEVICE_CMD_INFO_21,
    SPI_DEVICE_CMD_INFO_22,
    SPI_DEVICE_CMD_INFO_23,
    SPI_DEVICE_CMD_INFO_EN4B,
    SPI_DEVICE_CMD_INFO_EX4B,
    SPI_DEVICE_CMD_INFO_WREN,
    SPI_DEVICE_CMD_INFO_WRDI,
    SPI_DEVICE_TPM_CAP,
    SPI_DEVICE_TPM_CFG,
    SPI_DEVICE_TPM_STATUS,
    SPI_DEVICE_TPM_ACCESS_0,
    SPI_DEVICE_TPM_ACCESS_1,
    SPI_DEVICE_TPM_STS,
    SPI_DEVICE_TPM_INTF_CAPABILITY,
    SPI_DEVICE_TPM_INT_ENABLE,
    SPI_DEVICE_TPM_INT_VECTOR,
    SPI_DEVICE_TPM_INT_STATUS,
    SPI_DEVICE_TPM_DID_VID,
    SPI_DEVICE_TPM_RID,
    SPI_DEVICE_TPM_CMD_ADDR,
    SPI_DEVICE_TPM_READ_FIFO,
    SPI_DEVICE_TPM_WRITE_FIFO
  } spi_device_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] SPI_DEVICE_PERMIT [73] = '{
    4'b 0001, // index[ 0] SPI_DEVICE_INTR_STATE
    4'b 0001, // index[ 1] SPI_DEVICE_INTR_ENABLE
    4'b 0001, // index[ 2] SPI_DEVICE_INTR_TEST
    4'b 0001, // index[ 3] SPI_DEVICE_ALERT_TEST
    4'b 0001, // index[ 4] SPI_DEVICE_CONTROL
    4'b 1111, // index[ 5] SPI_DEVICE_CFG
    4'b 0001, // index[ 6] SPI_DEVICE_STATUS
    4'b 0001, // index[ 7] SPI_DEVICE_INTERCEPT_EN
    4'b 1111, // index[ 8] SPI_DEVICE_LAST_READ_ADDR
    4'b 0111, // index[ 9] SPI_DEVICE_FLASH_STATUS
    4'b 0011, // index[10] SPI_DEVICE_JEDEC_CC
    4'b 0111, // index[11] SPI_DEVICE_JEDEC_ID
    4'b 0011, // index[12] SPI_DEVICE_READ_THRESHOLD
    4'b 1111, // index[13] SPI_DEVICE_MAILBOX_ADDR
    4'b 0011, // index[14] SPI_DEVICE_UPLOAD_STATUS
    4'b 0111, // index[15] SPI_DEVICE_UPLOAD_STATUS2
    4'b 0001, // index[16] SPI_DEVICE_UPLOAD_CMDFIFO
    4'b 1111, // index[17] SPI_DEVICE_UPLOAD_ADDRFIFO
    4'b 1111, // index[18] SPI_DEVICE_CMD_FILTER_0
    4'b 1111, // index[19] SPI_DEVICE_CMD_FILTER_1
    4'b 1111, // index[20] SPI_DEVICE_CMD_FILTER_2
    4'b 1111, // index[21] SPI_DEVICE_CMD_FILTER_3
    4'b 1111, // index[22] SPI_DEVICE_CMD_FILTER_4
    4'b 1111, // index[23] SPI_DEVICE_CMD_FILTER_5
    4'b 1111, // index[24] SPI_DEVICE_CMD_FILTER_6
    4'b 1111, // index[25] SPI_DEVICE_CMD_FILTER_7
    4'b 1111, // index[26] SPI_DEVICE_ADDR_SWAP_MASK
    4'b 1111, // index[27] SPI_DEVICE_ADDR_SWAP_DATA
    4'b 1111, // index[28] SPI_DEVICE_PAYLOAD_SWAP_MASK
    4'b 1111, // index[29] SPI_DEVICE_PAYLOAD_SWAP_DATA
    4'b 1111, // index[30] SPI_DEVICE_CMD_INFO_0
    4'b 1111, // index[31] SPI_DEVICE_CMD_INFO_1
    4'b 1111, // index[32] SPI_DEVICE_CMD_INFO_2
    4'b 1111, // index[33] SPI_DEVICE_CMD_INFO_3
    4'b 1111, // index[34] SPI_DEVICE_CMD_INFO_4
    4'b 1111, // index[35] SPI_DEVICE_CMD_INFO_5
    4'b 1111, // index[36] SPI_DEVICE_CMD_INFO_6
    4'b 1111, // index[37] SPI_DEVICE_CMD_INFO_7
    4'b 1111, // index[38] SPI_DEVICE_CMD_INFO_8
    4'b 1111, // index[39] SPI_DEVICE_CMD_INFO_9
    4'b 1111, // index[40] SPI_DEVICE_CMD_INFO_10
    4'b 1111, // index[41] SPI_DEVICE_CMD_INFO_11
    4'b 1111, // index[42] SPI_DEVICE_CMD_INFO_12
    4'b 1111, // index[43] SPI_DEVICE_CMD_INFO_13
    4'b 1111, // index[44] SPI_DEVICE_CMD_INFO_14
    4'b 1111, // index[45] SPI_DEVICE_CMD_INFO_15
    4'b 1111, // index[46] SPI_DEVICE_CMD_INFO_16
    4'b 1111, // index[47] SPI_DEVICE_CMD_INFO_17
    4'b 1111, // index[48] SPI_DEVICE_CMD_INFO_18
    4'b 1111, // index[49] SPI_DEVICE_CMD_INFO_19
    4'b 1111, // index[50] SPI_DEVICE_CMD_INFO_20
    4'b 1111, // index[51] SPI_DEVICE_CMD_INFO_21
    4'b 1111, // index[52] SPI_DEVICE_CMD_INFO_22
    4'b 1111, // index[53] SPI_DEVICE_CMD_INFO_23
    4'b 1111, // index[54] SPI_DEVICE_CMD_INFO_EN4B
    4'b 1111, // index[55] SPI_DEVICE_CMD_INFO_EX4B
    4'b 1111, // index[56] SPI_DEVICE_CMD_INFO_WREN
    4'b 1111, // index[57] SPI_DEVICE_CMD_INFO_WRDI
    4'b 0111, // index[58] SPI_DEVICE_TPM_CAP
    4'b 0001, // index[59] SPI_DEVICE_TPM_CFG
    4'b 0111, // index[60] SPI_DEVICE_TPM_STATUS
    4'b 1111, // index[61] SPI_DEVICE_TPM_ACCESS_0
    4'b 0001, // index[62] SPI_DEVICE_TPM_ACCESS_1
    4'b 1111, // index[63] SPI_DEVICE_TPM_STS
    4'b 1111, // index[64] SPI_DEVICE_TPM_INTF_CAPABILITY
    4'b 1111, // index[65] SPI_DEVICE_TPM_INT_ENABLE
    4'b 0001, // index[66] SPI_DEVICE_TPM_INT_VECTOR
    4'b 1111, // index[67] SPI_DEVICE_TPM_INT_STATUS
    4'b 1111, // index[68] SPI_DEVICE_TPM_DID_VID
    4'b 0001, // index[69] SPI_DEVICE_TPM_RID
    4'b 1111, // index[70] SPI_DEVICE_TPM_CMD_ADDR
    4'b 1111, // index[71] SPI_DEVICE_TPM_READ_FIFO
    4'b 0001  // index[72] SPI_DEVICE_TPM_WRITE_FIFO
  };

endpackage
