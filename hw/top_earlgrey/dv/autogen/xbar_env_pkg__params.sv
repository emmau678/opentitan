// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// xbar_env_pkg__params generated by `topgen.py` tool


// List of Xbar device memory map
tl_device_t xbar_devices[$] = '{
    '{"rom", '{
        '{32'h00008000, 32'h0000bfff}
    }},
    '{"debug_mem", '{
        '{32'h1a110000, 32'h1a110fff}
    }},
    '{"ram_main", '{
        '{32'h10000000, 32'h1000ffff}
    }},
    '{"eflash", '{
        '{32'h20000000, 32'h2007ffff}
    }},
    '{"flash_ctrl", '{
        '{32'h40030000, 32'h40030fff}
    }},
    '{"hmac", '{
        '{32'h40120000, 32'h40120fff}
    }},
    '{"kmac", '{
        '{32'h41120000, 32'h41120fff}
    }},
    '{"aes", '{
        '{32'h40110000, 32'h40110fff}
    }},
    '{"entropy_src", '{
        '{32'h41160000, 32'h41160fff}
    }},
    '{"csrng", '{
        '{32'h41150000, 32'h41150fff}
    }},
    '{"edn0", '{
        '{32'h41170000, 32'h41170fff}
    }},
    '{"edn1", '{
        '{32'h41180000, 32'h41180fff}
    }},
    '{"rv_plic", '{
        '{32'h40090000, 32'h40090fff}
    }},
    '{"pinmux", '{
        '{32'h40070000, 32'h40070fff}
    }},
    '{"padctrl", '{
        '{32'h40160000, 32'h40160fff}
    }},
    '{"alert_handler", '{
        '{32'h411b0000, 32'h411b0fff}
    }},
    '{"nmi_gen", '{
        '{32'h411c0000, 32'h411c0fff}
    }},
    '{"otbn", '{
        '{32'h50000000, 32'h5000ffff}
    }},
    '{"keymgr", '{
        '{32'h401a0000, 32'h401a0fff}
    }},
    '{"uart", '{
        '{32'h40000000, 32'h40000fff}
    }},
    '{"gpio", '{
        '{32'h40010000, 32'h40010fff}
    }},
    '{"spi_device", '{
        '{32'h40020000, 32'h40020fff}
    }},
    '{"rv_timer", '{
        '{32'h40080000, 32'h40080fff}
    }},
    '{"usbdev", '{
        '{32'h40150000, 32'h40150fff}
    }},
    '{"pwrmgr", '{
        '{32'h400a0000, 32'h400a0fff}
    }},
    '{"rstmgr", '{
        '{32'h400b0000, 32'h400b0fff}
    }},
    '{"clkmgr", '{
        '{32'h400c0000, 32'h400c0fff}
    }},
    '{"ram_ret", '{
        '{32'h18000000, 32'h18000fff}
    }},
    '{"otp_ctrl", '{
        '{32'h401b0000, 32'h401b3fff}
    }},
    '{"sensor_ctrl", '{
        '{32'h40170000, 32'h40170fff}
    }},
    '{"ast_wrapper", '{
        '{32'h40180000, 32'h40180fff}
    }}};

  // List of Xbar hosts
tl_host_t xbar_hosts[$] = '{
    '{"corei", 0, '{
        "rom",
        "debug_mem",
        "ram_main",
        "eflash"}}
    ,
    '{"cored", 1, '{
        "rom",
        "debug_mem",
        "ram_main",
        "eflash",
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
        "ast_wrapper",
        "flash_ctrl",
        "aes",
        "entropy_src",
        "csrng",
        "edn0",
        "edn1",
        "hmac",
        "rv_plic",
        "pinmux",
        "padctrl",
        "alert_handler",
        "nmi_gen",
        "otbn",
        "keymgr",
        "kmac"}}
    ,
    '{"dm_sba", 2, '{
        "rom",
        "ram_main",
        "eflash",
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
        "ast_wrapper",
        "flash_ctrl",
        "aes",
        "entropy_src",
        "csrng",
        "edn0",
        "edn1",
        "hmac",
        "rv_plic",
        "pinmux",
        "padctrl",
        "alert_handler",
        "nmi_gen",
        "otbn",
        "kmac"}}
};
