// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// xbar_env_pkg__params generated by `tlgen.py` tool


// List of Xbar device memory map
tl_device_t xbar_devices[$] = '{
    '{"uart0", '{
        '{32'h40000000, 32'h4000003f}
    }},
    '{"uart1", '{
        '{32'h40010000, 32'h4001003f}
    }},
    '{"uart2", '{
        '{32'h40020000, 32'h4002003f}
    }},
    '{"uart3", '{
        '{32'h40030000, 32'h4003003f}
    }},
    '{"i2c0", '{
        '{32'h40080000, 32'h4008007f}
    }},
    '{"i2c1", '{
        '{32'h40090000, 32'h4009007f}
    }},
    '{"i2c2", '{
        '{32'h400a0000, 32'h400a007f}
    }},
    '{"pattgen", '{
        '{32'h400e0000, 32'h400e003f}
    }},
    '{"pwm_aon", '{
        '{32'h40450000, 32'h4045007f}
    }},
    '{"gpio", '{
        '{32'h40040000, 32'h4004003f}
    }},
    '{"spi_device", '{
        '{32'h40050000, 32'h40051fff}
    }},
    '{"rv_timer", '{
        '{32'h40100000, 32'h401001ff}
    }},
    '{"pwrmgr_aon", '{
        '{32'h40400000, 32'h4040007f}
    }},
    '{"rstmgr_aon", '{
        '{32'h40410000, 32'h4041007f}
    }},
    '{"clkmgr_aon", '{
        '{32'h40420000, 32'h4042007f}
    }},
    '{"pinmux_aon", '{
        '{32'h40460000, 32'h40460fff}
    }},
    '{"otp_ctrl__core", '{
        '{32'h40130000, 32'h40130fff}
    }},
    '{"otp_ctrl__prim", '{
        '{32'h40138000, 32'h4013801f}
    }},
    '{"lc_ctrl", '{
        '{32'h40140000, 32'h401400ff}
    }},
    '{"sensor_ctrl_aon", '{
        '{32'h40490000, 32'h4049003f}
    }},
    '{"alert_handler", '{
        '{32'h40150000, 32'h401507ff}
    }},
    '{"sram_ctrl_ret_aon__regs", '{
        '{32'h40500000, 32'h4050001f}
    }},
    '{"sram_ctrl_ret_aon__ram", '{
        '{32'h40600000, 32'h40600fff}
    }},
    '{"aon_timer_aon", '{
        '{32'h40470000, 32'h4047003f}
    }},
    '{"sysrst_ctrl_aon", '{
        '{32'h40430000, 32'h404300ff}
    }},
    '{"adc_ctrl_aon", '{
        '{32'h40440000, 32'h4044007f}
    }},
    '{"ast", '{
        '{32'h40480000, 32'h404803ff}
}}};

  // List of Xbar hosts
tl_host_t xbar_hosts[$] = '{
    '{"main", 0, '{
        "uart0",
        "uart1",
        "uart2",
        "uart3",
        "i2c0",
        "i2c1",
        "i2c2",
        "pattgen",
        "gpio",
        "spi_device",
        "rv_timer",
        "pwrmgr_aon",
        "rstmgr_aon",
        "clkmgr_aon",
        "pinmux_aon",
        "otp_ctrl__core",
        "otp_ctrl__prim",
        "lc_ctrl",
        "sensor_ctrl_aon",
        "alert_handler",
        "ast",
        "sram_ctrl_ret_aon__ram",
        "sram_ctrl_ret_aon__regs",
        "aon_timer_aon",
        "adc_ctrl_aon",
        "sysrst_ctrl_aon",
        "pwm_aon"}}
};
