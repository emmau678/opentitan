// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

use anyhow::Result;
use cryptoki::object::Attribute;
use cryptoki::session::Session;
use serde::{Deserialize, Serialize};
use serde_annotate::Annotate;
use std::any::Any;
use std::path::PathBuf;

use crate::commands::{BasicResult, Dispatch};
use crate::error::HsmError;
use crate::module::Module;
use crate::util::attribute::KeyType;
use crate::util::helper;
use crate::util::signing::SignData;

#[derive(clap::Args, Debug, Serialize, Deserialize)]
pub struct Verify {
    #[arg(long)]
    id: Option<String>,
    #[arg(short, long)]
    label: Option<String>,
    #[arg(short, long, value_enum, default_value = "sha256-hash")]
    format: SignData,
    /// Reverse the input data and result (for little-endian targets).
    #[arg(short = 'r', long)]
    little_endian: bool,
    input: PathBuf,
    signature: PathBuf,
}

#[typetag::serde(name = "ecdsa-verify")]
impl Dispatch for Verify {
    fn run(
        &self,
        _context: &dyn Any,
        _hsm: &Module,
        session: Option<&Session>,
    ) -> Result<Box<dyn Annotate>> {
        let session = session.ok_or(HsmError::SessionRequired)?;
        let mut attrs = helper::search_spec(self.id.as_deref(), self.label.as_deref())?;
        attrs.push(Attribute::KeyType(KeyType::Ec.try_into()?));
        attrs.push(Attribute::Verify(true));
        let object = helper::find_one_object(session, &attrs)?;

        let mut data = helper::read_file(&self.input)?;
        if self.little_endian {
            data.reverse();
        }
        let data = self.format.prepare(KeyType::Ec, &data)?;
        let mechanism = self.format.mechanism(KeyType::Ec)?;
        let mut signature = helper::read_file(&self.signature)?;
        if self.little_endian {
            signature.reverse();
        }
        session.verify(&mechanism, object, &data, &signature)?;
        Ok(Box::<BasicResult>::default())
    }
}
