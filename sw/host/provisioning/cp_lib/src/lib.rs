// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

use std::time::Duration;

use anyhow::{Context, Result};
use arrayvec::ArrayVec;
use clap::{ArgAction, Args, Parser};
use hex::decode;

use opentitanlib::app::TransportWrapper;
use opentitanlib::dif::lc_ctrl::{DifLcCtrlState, DifLcCtrlToken, LcCtrlReg};
use opentitanlib::io::jtag::JtagTap;
use opentitanlib::test_utils::init::InitializeTest;
use opentitanlib::test_utils::lc_transition::trigger_lc_transition;
use opentitanlib::test_utils::load_sram_program::{
    ExecutionMode, ExecutionResult, SramProgramParams,
};
use opentitanlib::test_utils::rpc::{UartRecv, UartSend};
use opentitanlib::test_utils::status::Status;
use opentitanlib::uart::console::UartConsole;

mod provisioning_command;
pub mod provisioning_data;
use provisioning_command::CpProvisioningCommand;
pub use provisioning_data::ManufCpProvisioningData;

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

    /// Wafer Authentication Secrete to provision.
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

/// Provisioning action command-line parameters, namely, the provisioning commands to send.
#[derive(Debug, Args, Clone)]
pub struct ManufCpProvisioningActions {
    #[arg(
        long,
        action = ArgAction::SetTrue,
        help = "Whether or not to perform all CP provisioning steps."
    )]
    pub all_steps: bool,

    #[arg(
        long,
        action = ArgAction::SetTrue,
        conflicts_with = "all_steps",
        help = "Whether or not to transition the chip from RAW to TEST_UNLOCKED0.",
    )]
    pub unlock_raw: bool,

    #[arg(
        long,
        action = ArgAction::SetTrue,
        conflicts_with = "all_steps",
        help = "Whether or not to erase the device_id/manuf_state flash info page."
    )]
    pub flash_info_erase_device_id_and_manuf_state: bool,

    #[arg(
        long,
        action = ArgAction::SetTrue,
        conflicts_with = "all_steps",
        help = "Whether or not to erase the wafer auth secret flash info page."
    )]
    pub flash_info_erase_wafer_auth_secret: bool,

    #[arg(
        long,
        action = ArgAction::SetTrue,
        conflicts_with = "all_steps",
        help = "Whether or not to write the device_id/manuf_state flash info page."
    )]
    pub flash_info_write_device_id_and_manuf_state: bool,

    #[arg(
        long,
        action = ArgAction::SetTrue,
        conflicts_with = "all_steps",
        help = "Whether or not to write the wafer_auth_secret flash info page."
    )]
    pub flash_info_write_wafer_auth_secret: bool,

    #[arg(
        long,
        action = ArgAction::SetTrue,
        conflicts_with = "all_steps",
        help = "Whether or not to write and lock the OTP secret0 partition (test tokens)."
    )]
    pub otp_write_and_lock_secret0: bool,

    #[arg(
        long,
        action = ArgAction::SetTrue,
        conflicts_with = "all_steps",
        help = "Whether or not to transition the chip to TEST_LOCKED0."
    )]
    pub lock_chip: bool,
}

#[derive(Debug, Parser)]
pub struct Opts {
    #[command(flatten)]
    pub init: InitializeTest,

    #[command(flatten)]
    pub sram_program: SramProgramParams,

    #[command(flatten)]
    pub provisioning_data: ManufCpProvisioningDataInput,

    #[command(flatten)]
    pub provisioning_actions: ManufCpProvisioningActions,

    /// Console receive timeout.
    #[arg(long, value_parser = humantime::parse_duration, default_value = "600s")]
    pub timeout: Duration,
}

pub fn unlock_raw(opts: &Opts, transport: &TransportWrapper) -> Result<()> {
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

    // ROM execution is not enabled in the OTP so we can safely reconnect to the LC TAP after
    // the transition without risking the chip resetting.
    trigger_lc_transition(
        transport,
        jtag.clone(),
        DifLcCtrlState::TestUnlocked0,
        Some(token_words),
        true,
        opts.init.bootstrap.options.reset_delay,
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
    opts: &Opts,
    transport: &TransportWrapper,
    provisioning_data: &ManufCpProvisioningData,
) -> Result<()> {
    // Set CPU TAP straps, reset, and connect to the JTAG interface.
    transport.pin_strapping("PINMUX_TAP_RISCV")?.apply()?;
    transport.reset_target(opts.init.bootstrap.options.reset_delay, true)?;
    let jtag = opts.init.jtag_params.create(transport)?;
    jtag.connect(JtagTap::RiscvTap)?;

    // Reset and halt the CPU to ensure we are in a known state, and clear out any ROM messages
    // printed over the console.
    jtag.reset(/*run=*/ false)?;
    let uart = transport.uart("console")?;
    uart.clear_rx_buffer()?;

    // Load and execute the SRAM program that contains the provisioning code.
    let result = opts
        .sram_program
        .load_and_execute(&jtag, ExecutionMode::Jump)?;
    match result {
        ExecutionResult::Executing => log::info!("SRAM program loaded and is executing."),
        _ => panic!("SRAM program load/execution failed: {:?}.", result),
    }

    // Get UART, set flow control, and wait for test to start running.
    let uart = transport.uart("console")?;
    uart.set_flow_control(true)?;
    let _ = UartConsole::wait_for(
        &*uart,
        r"Waiting for CP provisioning data ...",
        opts.timeout,
    )?;

    // Inject provisioning data into the device.
    provisioning_data.send(&*uart)?;

    // Inject provisioning commands.
    let mut send_done: bool = false;
    if opts.provisioning_actions.all_steps {
        CpProvisioningCommand::EraseAndWriteAll.send(&*uart)?;
        Status::recv(&*uart, opts.timeout, false)?;
        send_done = true;
    }
    if opts
        .provisioning_actions
        .flash_info_erase_device_id_and_manuf_state
    {
        CpProvisioningCommand::FlashInfoEraseDeviceIdAndManufState.send(&*uart)?;
        Status::recv(&*uart, opts.timeout, false)?;
        send_done = true;
    }
    if opts.provisioning_actions.flash_info_erase_wafer_auth_secret {
        CpProvisioningCommand::FlashInfoEraseWaferAuthSecret.send(&*uart)?;
        Status::recv(&*uart, opts.timeout, false)?;
        send_done = true;
    }
    if opts
        .provisioning_actions
        .flash_info_write_device_id_and_manuf_state
    {
        CpProvisioningCommand::FlashInfoWriteDeviceIdAndManufState.send(&*uart)?;
        Status::recv(&*uart, opts.timeout, false)?;
        send_done = true;
    }
    if opts.provisioning_actions.flash_info_write_wafer_auth_secret {
        CpProvisioningCommand::FlashInfoWriteWaferAuthSecret.send(&*uart)?;
        Status::recv(&*uart, opts.timeout, false)?;
        send_done = true;
    }
    if opts.provisioning_actions.otp_write_and_lock_secret0 {
        CpProvisioningCommand::OtpSecret0WriteAndLock.send(&*uart)?;
        Status::recv(&*uart, opts.timeout, false)?;
        send_done = true;
    }
    if send_done {
        CpProvisioningCommand::Done.send(&*uart)?;
        Status::recv(&*uart, opts.timeout, false)?;
    }

    // Once the SRAM program has sent a response, we can continue with an LC transition to
    // mission mode, initiated on the host side.
    jtag.disconnect()?;
    transport.pin_strapping("PINMUX_TAP_RISCV")?.remove()?;

    Ok(())
}

pub fn reset_and_lock(opts: &Opts, transport: &TransportWrapper) -> Result<()> {
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

    // CPU execution is not enabled in TEST_LOCKED0 so we can safely reconnect to the LC TAP
    // after the transition without risking the chip resetting.
    trigger_lc_transition(
        transport,
        jtag.clone(),
        DifLcCtrlState::TestLocked0,
        None,
        true,
        opts.init.bootstrap.options.reset_delay,
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

pub fn hex_string_to_u32_arrayvec<const N: usize>(hex_str: &str) -> Result<ArrayVec<u32, N>> {
    let hex_str_no_sep = hex_str.replace('_', "");
    let hex_str_prefix = "0x";
    let sanitized_hex_str = if hex_str.starts_with(hex_str_prefix) {
        hex_str_no_sep.strip_prefix(hex_str_prefix).unwrap()
    } else {
        hex_str_no_sep.as_str()
    };
    Ok(decode(sanitized_hex_str)?
        .chunks(4)
        .map(|bytes| u32::from_be_bytes(bytes.try_into().unwrap()))
        .collect::<ArrayVec<u32, N>>())
}
