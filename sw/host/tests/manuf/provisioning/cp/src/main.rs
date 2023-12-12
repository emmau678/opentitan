// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

use std::time::Duration;

use anyhow::Result;
use clap::Parser;

use cp_lib::{reset_and_lock, run_sram_cp_provision, ManufCpProvisioningDataInput};
use opentitanlib::test_utils::init::InitializeTest;
use opentitanlib::test_utils::load_sram_program::SramProgramParams;
use ujson_lib::provisioning_data::ManufCpProvisioningData;
use util_lib::hex_string_to_u32_arrayvec;

#[derive(Debug, Parser)]
struct Opts {
    #[command(flatten)]
    init: InitializeTest,

    #[command(flatten)]
    sram_program: SramProgramParams,

    #[command(flatten)]
    provisioning_data: ManufCpProvisioningDataInput,

    /// Console receive timeout.
    #[arg(long, value_parser = humantime::parse_duration, default_value = "600s")]
    timeout: Duration,
}

fn main() -> Result<()> {
    let opts = Opts::parse();
    opts.init.init_logging();
    let transport = opts.init.init_target()?;

    let provisioning_data = ManufCpProvisioningData {
        device_id: hex_string_to_u32_arrayvec::<8>(opts.provisioning_data.device_id.as_str())?,
        manuf_state: hex_string_to_u32_arrayvec::<8>(opts.provisioning_data.manuf_state.as_str())?,
        wafer_auth_secret: hex_string_to_u32_arrayvec::<8>(
            opts.provisioning_data.wafer_auth_secret.as_str(),
        )?,
        test_unlock_token: hex_string_to_u32_arrayvec::<4>(
            opts.provisioning_data.test_unlock_token.as_str(),
        )?,
        test_exit_token: hex_string_to_u32_arrayvec::<4>(
            opts.provisioning_data.test_exit_token.as_str(),
        )?,
    };

    run_sram_cp_provision(
        &transport,
        &opts.init.jtag_params,
        opts.init.bootstrap.options.reset_delay,
        &opts.sram_program,
        &provisioning_data,
        opts.timeout,
    )?;
    reset_and_lock(
        &transport,
        &opts.init.jtag_params,
        opts.init.bootstrap.options.reset_delay,
    )?;

    Ok(())
}
