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

use top_earlgrey::top_earlgrey;

// Generated by the `lc_raw_unlock_token` Bazel rule from `//rules/lc.bzl`.
mod lc_raw_unlock_token;

#[derive(Debug, Parser)]
struct Opts {
    #[command(flatten)]
    init: InitializeTest,
}

fn volatile_raw_unlock_with_reconnection_to_lc_tap(
    opts: &Opts,
    token_words: [u32; 4],
    transport: &TransportWrapper,
) -> Result<()> {
    // Set the TAP straps for the lifecycle controller and reset.
    transport
        .pin_strapping("PINMUX_TAP_LC")?
        .apply()
        .context("failed to apply LC TAP strapping")?;
    transport
        .reset_target(opts.init.bootstrap.options.reset_delay, true)
        .context("failed to reset")?;

    // Connect to the LC TAP via JTAG.
    let mut jtag = opts.init.jtag_params.create(transport)?;
    jtag.connect(JtagTap::LcTap)
        .context("failed to connect to LC TAP over JTAG")?;

    // ROM execution is not enabled in the OTP so we can safely reconnect to the LC TAP after
    // the transition without risking the chip resetting.
    jtag = lc_transition::trigger_volatile_raw_unlock(
        transport,
        jtag,
        DifLcCtrlState::TestUnlocked0,
        Some(token_words),
        /*use_external_clk=*/ true,
        JtagTap::LcTap,
        &opts.init.jtag_params,
    )
    .context("failed to transition to TEST_UNLOCKED0")?;

    // Check that LC state is `TEST_UNLOCKED0` over the LC TAP.
    let state =
        DifLcCtrlState::from_redundant_encoding(jtag.read_lc_ctrl_reg(&LcCtrlReg::LcState)?)?;
    assert_eq!(state, DifLcCtrlState::TestUnlocked0);

    jtag.disconnect()?;

    Ok(())
}

fn volatile_raw_unlock_with_reconnection_to_rv_tap(
    opts: &Opts,
    token_words: [u32; 4],
    transport: &TransportWrapper,
) -> Result<()> {
    // Set the TAP straps for the lifecycle controller and reset.
    transport
        .pin_strapping("PINMUX_TAP_LC")?
        .apply()
        .context("failed to apply LC TAP strapping")?;
    transport
        .reset_target(opts.init.bootstrap.options.reset_delay, true)
        .context("failed to reset")?;

    // Connect to the LC TAP via JTAG.
    let mut jtag = opts.init.jtag_params.create(transport)?;
    jtag.connect(JtagTap::LcTap)
        .context("failed to connect to LC TAP over JTAG")?;

    // ROM execution is not enabled in the OTP so we can safely reconnect to the LC TAP after
    // the transition without risking the chip resetting.
    jtag = lc_transition::trigger_volatile_raw_unlock(
        transport,
        jtag,
        DifLcCtrlState::TestUnlocked0,
        Some(token_words),
        /*use_external_clk=*/ true,
        JtagTap::RiscvTap,
        &opts.init.jtag_params,
    )
    .context("failed to transition to TEST_UNLOCKED0")?;

    // Check that LC state is `TEST_UNLOCKED0` over the RV TAP.
    let mut state = [0u32];
    jtag.read_memory32(
        top_earlgrey::LC_CTRL_BASE_ADDR as u32 + LcCtrlReg::LcState as u32,
        &mut state,
    )?;
    assert_eq!(
        DifLcCtrlState::from_redundant_encoding(state[0])?,
        DifLcCtrlState::TestUnlocked0
    );

    jtag.disconnect()?;

    Ok(())
}

fn main() -> Result<()> {
    let opts = Opts::parse();
    opts.init.init_logging();
    let transport = opts.init.init_target()?;

    // Provide the hashed `RAW_UNLOCK` token. Note, it is important the hashed token is provided
    // directly, as a volatile LC operation does not go through KMAC.
    let token =
        DifLcCtrlToken::from(lc_raw_unlock_token::RND_CNST_RAW_UNLOCK_TOKEN_HASHED.to_le_bytes());
    let token_words = token.into_register_values();

    execute_test!(
        volatile_raw_unlock_with_reconnection_to_lc_tap,
        &opts,
        token_words,
        &transport
    );
    execute_test!(
        volatile_raw_unlock_with_reconnection_to_rv_tap,
        &opts,
        token_words,
        &transport
    );

    Ok(())
}
