// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

use std::time::Duration;

use anyhow::{Context, Result};
use clap::Args;

use opentitanlib::app::TransportWrapper;
use opentitanlib::dif::lc_ctrl::{DifLcCtrlState, DifLcCtrlToken, LcCtrlReg};
use opentitanlib::io::jtag::{JtagParams, JtagTap};
use opentitanlib::test_utils::lc_transition::trigger_lc_transition;
use opentitanlib::test_utils::load_sram_program::{
    ExecutionMode, ExecutionResult, SramProgramParams,
};
use opentitanlib::test_utils::rpc::UartSend;
use opentitanlib::uart::console::UartConsole;
use ujson_lib::provisioning_data::ManufCpProvisioningData;

// Generated by the `lc_raw_unlock_token` Bazel rule from `//rules/lc.bzl`.
mod lc_raw_unlock_token;

/// Provisioning data command-line parameters.
#[derive(Debug, Args, Clone)]
pub struct ManufCpProvisioningDataInput {
    // TODO(#19456): construct device ID from building blocks
    /// Device ID to provision.
    #[arg(
        long,
        default_value = "0x00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000"
    )]
    pub device_id: String,

    /// Manufacturing State information to provision.
    #[arg(
        long,
        default_value = "0x00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000"
    )]
    pub manuf_state: String,

    /// Wafer Authentication Secret to provision.
    #[arg(
        long,
        default_value = "0x00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000"
    )]
    pub wafer_auth_secret: String,

    /// TestUnlock token to provision.
    #[arg(long, default_value = "0x00000000_00000000_00000000_00000000")]
    pub test_unlock_token: String,

    /// TestExit token to provision.
    #[arg(long, default_value = "0x00000000_00000000_00000000_00000000")]
    pub test_exit_token: String,
}

pub fn unlock_raw(
    transport: &TransportWrapper,
    jtag_params: &JtagParams,
    reset_delay: Duration,
) -> Result<()> {
    // Set the TAP straps for the lifecycle controller and reset.
    transport
        .pin_strapping("PINMUX_TAP_LC")?
        .apply()
        .context("failed to apply LC TAP strapping")?;
    transport
        .reset_target(reset_delay, true)
        .context("failed to reset")?;

    // Connect to the LC TAP via JTAG.
    let mut jtag = jtag_params.create(transport)?;
    jtag.connect(JtagTap::LcTap)
        .context("failed to connect to LC TAP over JTAG")?;

    // Provide the `RAW_UNLOCK` token
    let token = DifLcCtrlToken::from(lc_raw_unlock_token::RND_CNST_RAW_UNLOCK_TOKEN.to_le_bytes());
    let token_words = token.into_register_values();

    // ROM execution is not enabled in the OTP so we can safely reconnect to the LC TAP after
    // the transition without risking the chip resetting.
    trigger_lc_transition(
        transport,
        &mut *jtag,
        DifLcCtrlState::TestUnlocked0,
        Some(token_words),
        /*use_external_clk=*/
        true, // AST will NOT be calibrated yet, so we need ext_clk.
        reset_delay,
        Some(JtagTap::LcTap),
    )
    .context("failed to transition to TEST_UNLOCKED0.")?;

    // Check that LC state is `TEST_UNLOCKED0`.
    let state = jtag.read_lc_ctrl_reg(&LcCtrlReg::LcState)?;
    assert_eq!(state, DifLcCtrlState::TestUnlocked0.redundant_encoding());
    jtag.disconnect()?;
    transport.pin_strapping("PINMUX_TAP_LC")?.remove()?;

    Ok(())
}

pub fn run_sram_cp_provision(
    transport: &TransportWrapper,
    jtag_params: &JtagParams,
    reset_delay: Duration,
    sram_program: &SramProgramParams,
    provisioning_data: &ManufCpProvisioningData,
    timeout: Duration,
) -> Result<()> {
    // Set CPU TAP straps, reset, and connect to the JTAG interface.
    transport.pin_strapping("PINMUX_TAP_RISCV")?.apply()?;
    transport.reset_target(reset_delay, true)?;
    let mut jtag = jtag_params.create(transport)?;
    jtag.connect(JtagTap::RiscvTap)?;

    // Reset and halt the CPU to ensure we are in a known state, and clear out any ROM messages
    // printed over the console.
    jtag.reset(/*run=*/ false)?;
    let uart = transport.uart("console")?;
    uart.clear_rx_buffer()?;

    // Load and execute the SRAM program that contains the provisioning code.
    let result = sram_program.load_and_execute(&mut *jtag, ExecutionMode::Jump)?;
    match result {
        ExecutionResult::Executing => log::info!("SRAM program loaded and is executing."),
        _ => panic!("SRAM program load/execution failed: {:?}.", result),
    }

    // Get UART, set flow control, and wait for test to start running.
    uart.set_flow_control(true)?;
    let _ = UartConsole::wait_for(&*uart, r"Waiting for CP provisioning data ...", timeout)?;

    // Inject provisioning data into the device.
    provisioning_data.send(&*uart)?;

    // Wait for provisioning operations to complete.
    let _ = UartConsole::wait_for(&*uart, r"CP provisioning done.", timeout)?;

    jtag.disconnect()?;
    transport.pin_strapping("PINMUX_TAP_RISCV")?.remove()?;

    Ok(())
}

pub fn reset_and_lock(
    transport: &TransportWrapper,
    jtag_params: &JtagParams,
    reset_delay: Duration,
) -> Result<()> {
    // Set the TAP straps for the lifecycle controller and reset.
    transport
        .pin_strapping("PINMUX_TAP_LC")?
        .apply()
        .context("failed to apply LC TAP strapping")?;
    transport
        .reset_target(reset_delay, true)
        .context("failed to reset")?;

    // Connect to the LC TAP via JTAG.
    let mut jtag = jtag_params.create(transport)?;
    jtag.connect(JtagTap::LcTap)
        .context("failed to connect to LC TAP over JTAG")?;

    // CPU execution is not enabled in TEST_LOCKED0 so we can safely reconnect to the LC TAP
    // after the transition without risking the chip resetting.
    trigger_lc_transition(
        transport,
        &mut *jtag,
        DifLcCtrlState::TestLocked0,
        None,
        /*use_external_clk=*/
        false, // AST will be calibrated by now, so no need for ext_clk.
        reset_delay,
        Some(JtagTap::LcTap),
    )
    .context("failed to transition to TEST_LOCKED0.")?;

    // Check that LC state is `TEST_LOCKED0`.
    let state = jtag.read_lc_ctrl_reg(&LcCtrlReg::LcState)?;
    assert_eq!(state, DifLcCtrlState::TestLocked0.redundant_encoding());
    jtag.disconnect()?;
    transport.pin_strapping("PINMUX_TAP_LC")?.remove()?;

    Ok(())
}
