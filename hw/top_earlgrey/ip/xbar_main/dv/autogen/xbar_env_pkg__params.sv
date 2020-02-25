// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// xbar_env_pkg__params generated by `tlgen.py` tool


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
    '{"peri", '{
        '{32'h40000000, 32'h40020fff},
        '{32'h40080000, 32'h40080fff},
        '{32'h40150000, 32'h40150fff}
    }},
    '{"flash_ctrl", '{
        '{32'h40030000, 32'h40030fff}
    }},
    '{"hmac", '{
        '{32'h40120000, 32'h40120fff}
    }},
    '{"aes", '{
        '{32'h40110000, 32'h40110fff}
    }},
    '{"rv_plic", '{
        '{32'h40090000, 32'h40090fff}
    }},
    '{"pinmux", '{
        '{32'h40070000, 32'h40070fff}
    }},
    '{"alert_handler", '{
        '{32'h40130000, 32'h40130fff}
    }},
    '{"nmi_gen", '{
        '{32'h40140000, 32'h40140fff}
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
        "peri",
        "flash_ctrl",
        "aes",
        "hmac",
        "rv_plic",
        "pinmux",
        "alert_handler",
        "nmi_gen"}}
    ,
    '{"dm_sba", 2, '{
        "rom",
        "ram_main",
        "eflash",
        "peri",
        "flash_ctrl",
        "aes",
        "hmac",
        "rv_plic",
        "pinmux",
        "alert_handler",
        "nmi_gen"}}
};
