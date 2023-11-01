// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//! This test performs a lifecycle transition from `TEST_UNLOCKED0` to `TEST_LOCKED0`.
//!
//! The `TEST_UNLOCK` token is generated by the `gen_test_unlock_token.py`
//! script in this test's directory. The token is programmed to the OTP via JTAG.

use anyhow::{Context, Result};
use clap::Parser;

use opentitanlib::app::TransportWrapper;
use opentitanlib::dif::lc_ctrl::{DifLcCtrlState, LcCtrlReg};
use opentitanlib::dif::otp_ctrl::{DaiParam, Partition};
use opentitanlib::execute_test;
use opentitanlib::io::jtag::{Jtag, JtagTap};
use opentitanlib::test_utils::init::InitializeTest;
use opentitanlib::test_utils::lc_transition;
use opentitanlib::test_utils::otp_ctrl::{OtpParam, OtpPartition};

#[derive(Debug, Parser)]
struct Opts {
    #[command(flatten)]
    init: InitializeTest,
}

/// Pre-image of the TEST_UNLOCK token that will be written to OTP.
const TEST_UNLOCK_TOKEN_PREIMAGE: [u32; 4] = [0xAAAAAAAA, 0xAAAAAAAA, 0xAAAAAAAA, 0xAAAAAAAA];
/// Post-image of the TEST_UNLOCK token as generated by `gen_test_unlock_token.py`.
const TEST_UNLOCK_TOKEN_POSTIMAGE: [u32; 4] = [0xc0bb8f81, 0x618ae065, 0x67fd75f3, 0xe6b9ec3f];

fn main() -> Result<()> {
    let opts = Opts::parse();
    opts.init.init_logging();

    let transport = opts.init.init_target()?;

    execute_test!(provision_token, &opts, &transport);
    execute_test!(test_lock, &opts, &transport);
    execute_test!(test_unlock, &opts, &transport);

    Ok(())
}

/// Provision the `TEST_UNLOCK` token, programming it into OTP.
fn provision_token(opts: &Opts, transport: &TransportWrapper) -> Result<()> {
    let mut jtag = reset_to_tap(opts, transport, JtagTap::RiscvTap)?;

    OtpParam::write_param(
        &mut *jtag,
        DaiParam::TestUnlockToken,
        &TEST_UNLOCK_TOKEN_POSTIMAGE,
    )
    .context("failed to write TEST_UNLOCK token to OTP")?;

    // Read back the token to verify it was written.
    let mut test_unlock_token = [0xff; 4];
    OtpParam::read_param(
        &mut *jtag,
        DaiParam::TestUnlockToken,
        &mut test_unlock_token,
    )
    .context("failed to read back TEST_UNLOCK token from OTP")?;

    assert_eq!(
        test_unlock_token, TEST_UNLOCK_TOKEN_POSTIMAGE,
        "check correct TEST_UNLOCK token can be read back from OTP"
    );

    // Lock the SECRET0 partition.
    OtpPartition::lock(&mut *jtag, Partition::SECRET0)
        .context("failed to lock SECRET0 partition")?;

    // Read its digest to ensure it's now locked.
    let digest = OtpPartition::read_digest(&mut *jtag, Partition::SECRET0)
        .context("failed to read SECRET0 digest")?;
    assert_ne!(digest, [0x00, 2]);

    jtag.disconnect()?;
    transport.pin_strapping("PINMUX_TAP_RISCV")?.remove()?;

    // Reset after locking to allow the token to be used for transitions.
    transport
        .reset_target(opts.init.bootstrap.options.reset_delay, true)
        .context("failed to reset")?;

    Ok(())
}

/// Test that the device can be locked.
fn test_lock(opts: &Opts, transport: &TransportWrapper) -> anyhow::Result<()> {
    let mut jtag = reset_to_tap(opts, transport, JtagTap::LcTap)?;

    // Check that LC state starts in `TEST_UNLOCKED0`.
    let state = jtag.read_lc_ctrl_reg(&LcCtrlReg::LcState)?;
    assert_eq!(state, DifLcCtrlState::TestUnlocked0.redundant_encoding());

    // CPU execution is not enabled in the `TEST_LOCKED0` state so we can
    // safely reconnect to the LC TAP after the transition without risking
    // the chip to be resetting.
    lc_transition::trigger_lc_transition(
        transport,
        &mut *jtag,
        DifLcCtrlState::TestLocked0,
        None,
        true,
        opts.init.bootstrap.options.reset_delay,
        Some(JtagTap::LcTap),
    )
    .context("failed to trigger transition to TEST_LOCKED0")?;

    // Check that LC state has transitioned to `TEST_LOCKED0`.
    let state = jtag.read_lc_ctrl_reg(&LcCtrlReg::LcState)?;
    assert_eq!(state, DifLcCtrlState::TestLocked0.redundant_encoding());

    jtag.disconnect()?;
    transport.pin_strapping("PINMUX_TAP_LC")?.remove()?;

    Ok(())
}

/// Test that the device can be unlock using the provisioned token.
fn test_unlock(opts: &Opts, transport: &TransportWrapper) -> anyhow::Result<()> {
    let mut jtag = reset_to_tap(opts, transport, JtagTap::LcTap)?;

    // Check that LC state is currently `TEST_LOCKED0`.
    let state = jtag.read_lc_ctrl_reg(&LcCtrlReg::LcState)?;
    assert_eq!(state, DifLcCtrlState::TestLocked0.redundant_encoding());

    // ROM execution is not enabled in the OTP so we can safely reconnect to the LC TAP after
    // the transition without risking the chip resetting.
    lc_transition::trigger_lc_transition(
        transport,
        &mut *jtag,
        DifLcCtrlState::TestUnlocked1,
        Some(TEST_UNLOCK_TOKEN_PREIMAGE),
        true,
        opts.init.bootstrap.options.reset_delay,
        Some(JtagTap::LcTap),
    )
    .context("failed to trigger transition to TEST_UNLOCKED1")?;

    // Check that LC state has transitioned to `TEST_UNLOCKED0`.
    let state = jtag.read_lc_ctrl_reg(&LcCtrlReg::LcState)?;
    assert_eq!(state, DifLcCtrlState::TestUnlocked1.redundant_encoding());

    jtag.disconnect()?;
    transport.pin_strapping("PINMUX_TAP_LC")?.remove()?;

    Ok(())
}

/// Reset the device into a particular TAP connection.
///
/// Returns a [`Jtag`] connection to the required TAP.
fn reset_to_tap<'t>(
    opts: &Opts,
    transport: &'t TransportWrapper,
    tap: JtagTap,
) -> anyhow::Result<Box<dyn Jtag + 't>> {
    let strapping = match tap {
        JtagTap::RiscvTap => "PINMUX_TAP_RISCV",
        JtagTap::LcTap => "PINMUX_TAP_LC",
    };

    transport
        .pin_strapping(strapping)?
        .apply()
        .with_context(|| format!("failed to apply {strapping} strapping"))?;
    transport
        .reset_target(opts.init.bootstrap.options.reset_delay, true)
        .context("failed to reset")?;

    let mut jtag = opts.init.jtag_params.create(transport)?;
    jtag.connect(tap)
        .with_context(|| format!("failed to connect to {tap:?} over JTAG"))?;

    Ok(jtag)
}
