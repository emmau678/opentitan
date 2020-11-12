// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// xbar_env_pkg__params generated by `tlgen.py` tool


// List of Xbar device memory map
tl_device_t xbar_devices[$] = '{
    '{"uart", '{
        '{32'h40000000, 32'h40000fff}
    }},
    '{"gpio", '{
        '{32'h40040000, 32'h40040fff}
    }},
    '{"spi_device", '{
        '{32'h40050000, 32'h40050fff}
    }},
    '{"rv_timer", '{
        '{32'h40100000, 32'h40100fff}
    }},
    '{"usbdev", '{
        '{32'h40500000, 32'h40500fff}
    }},
    '{"pwrmgr", '{
        '{32'h40400000, 32'h40400fff}
    }},
    '{"rstmgr", '{
        '{32'h40410000, 32'h40410fff}
    }},
    '{"clkmgr", '{
        '{32'h40420000, 32'h40420fff}
    }},
    '{"ram_ret", '{
        '{32'h18000000, 32'h18000fff}
    }},
    '{"otp_ctrl", '{
        '{32'h40130000, 32'h40133fff}
    }},
    '{"sensor_ctrl", '{
        '{32'h40110000, 32'h40110fff}
    }},
    '{"ast_wrapper", '{
        '{32'h40180000, 32'h40180fff}
}}};

  // List of Xbar hosts
tl_host_t xbar_hosts[$] = '{
    '{"main", 0, '{
        "uart",
        "gpio",
        "spi_device",
        "rv_timer",
        "usbdev",
        "pwrmgr",
        "rstmgr",
        "clkmgr",
        "ram_ret",
        "otp_ctrl",
        "sensor_ctrl",
        "ast_wrapper"}}
};
