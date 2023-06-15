// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//! This test performs a lifecycle transition from `RAW` to `TEST_UNLOCKED0`.

use anyhow::{Context, Result};
use clap::Parser;

use opentitanlib::app::TransportWrapper;
use opentitanlib::dif::lc_ctrl::{DifLcCtrlState, DifLcCtrlToken, LcCtrlReg};
use opentitanlib::execute_test;
use opentitanlib::io::jtag::JtagTap;
use opentitanlib::test_utils::init::InitializeTest;
use opentitanlib::test_utils::lc_transition;

// Generated by the `lc_raw_unlock_token` Bazel rule from `//rules/lc.bzl`.
mod lc_raw_unlock_token;

#[derive(Debug, Parser)]
struct Opts {
    #[command(flatten)]
    init: InitializeTest,
}

fn manuf_cp_unlock_raw(opts: &Opts, transport: &TransportWrapper) -> Result<()> {
    // Set the TAP straps for the lifecycle controller and reset.
    transport
        .pin_strapping("PINMUX_TAP_LC")?
        .apply()
        .context("failed to apply LC TAP strapping")?;
    transport
        .reset_target(opts.init.bootstrap.options.reset_delay, true)
        .context("failed to reset")?;

    // Connect to the LC TAP via JTAG.
    let jtag = opts.init.jtag_params.create(transport)?;
    jtag.connect(JtagTap::LcTap)
        .context("failed to connect to LC TAP over JTAG")?;

    // Provide the `RAW_UNLOCK` token
    let token = DifLcCtrlToken::from(lc_raw_unlock_token::RND_CNST_RAW_UNLOCK_TOKEN.to_le_bytes());
    let token_words = token.into_register_values();

    lc_transition::trigger_lc_transition(
        transport,
        jtag.clone(),
        DifLcCtrlState::TestUnlocked0,
        Some(token_words),
        true,
        opts.init.bootstrap.options.reset_delay,
    )
    .context("failed to transition to TEST_UNLOCKED0")?;

    // Check that LC state is `TEST_UNLOCKED0`.
    let state = jtag.read_lc_ctrl_reg(&LcCtrlReg::LcState)?;
    assert_eq!(state, DifLcCtrlState::TestUnlocked0.redundant_encoding());

    Ok(())
}

fn main() -> Result<()> {
    let opts = Opts::parse();
    opts.init.init_logging();
    let transport = opts.init.init_target()?;

    execute_test!(manuf_cp_unlock_raw, &opts, &transport);

    Ok(())
}
