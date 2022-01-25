// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "otbn_model.h"

#include <algorithm>
#include <cassert>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>

#include "iss_wrapper.h"
#include "otbn_model_dpi.h"
#include "otbn_trace_checker.h"
#include "sv_scoped.h"
#include "sv_utils.h"

extern "C" {
// These functions are only implemented if DesignScope != "", i.e. if we're
// running a block-level simulation. Code needs to check at runtime if
// otbn_rf_peek() and otbn_stack_element_peek() are available before calling
// them.
int otbn_rf_peek(int index, svBitVecVal *val) __attribute__((weak));
int otbn_stack_element_peek(int index, svBitVecVal *val) __attribute__((weak));
}

#define RUNNING_BIT (1U << 0)
#define CHECK_DUE_BIT (1U << 1)
#define FAILED_STEP_BIT (1U << 2)
#define FAILED_CMP_BIT (1U << 3)

// Read (the start of) the contents of a file at path as a vector of bytes.
// Expects num_bytes bytes of data. On failure, throws a std::runtime_error.
static Ecc32MemArea::EccWords read_words_from_file(const std::string &path,
                                                   size_t num_words) {
  std::filebuf fb;
  if (!fb.open(path.c_str(), std::ios::in | std::ios::binary)) {
    std::ostringstream oss;
    oss << "Cannot open the file '" << path << "'.";
    throw std::runtime_error(oss.str());
  }

  Ecc32MemArea::EccWords ret;
  ret.reserve(num_words);

  char minibuf[5];
  for (size_t i = 0; i < num_words; ++i) {
    std::streamsize chars_in = fb.sgetn(minibuf, 5);
    if (chars_in != 5) {
      std::ostringstream oss;
      oss << "Cannot read word " << i << " from " << path
          << " (expected 5 bytes, but actually got " << chars_in << ").";
      throw std::runtime_error(oss.str());
    }

    // The layout should be a validity byte (either 0 or 1), followed
    // by 4 bytes with a little-endian 32-bit word.
    uint8_t vld_byte = minibuf[0];
    if (vld_byte > 2) {
      std::ostringstream oss;
      oss << "Word " << i << " at " << path
          << " had a validity byte with value " << (int)vld_byte
          << "; not 0 or 1.";
      throw std::runtime_error(oss.str());
    }
    bool valid = vld_byte == 1;

    uint32_t word = 0;
    for (int j = 0; j < 4; ++j) {
      word |= (uint32_t)(uint8_t)minibuf[j + 1] << 8 * j;
    }

    ret.push_back(std::make_pair(valid, word));
  }

  return ret;
}

static std::vector<uint8_t> words_to_bytes(
    const Ecc32MemArea::EccWords &words) {
  std::vector<uint8_t> ret;
  ret.reserve(words.size() * 4);
  for (size_t i = 0; i < words.size(); ++i) {
    const Ecc32MemArea::EccWord &word = words[i];
    bool valid = word.first;
    uint32_t w32 = word.second;

    // Complain if the word has an invalid checksum. We don't support doing
    // that at the moment.
    if (!valid) {
      std::ostringstream oss;
      oss << "Cannot convert 32-bit word " << i
          << " to bytes because its valid flag is false.";
      throw std::runtime_error(oss.str());
    }

    for (int j = 0; j < 4; ++j) {
      ret.push_back((w32 >> 8 * j) & 0xff);
    }
  }
  return ret;
}

// Write some words to a new file at path. On failure, throws a
// std::runtime_error.
static void write_words_to_file(const std::string &path,
                                const Ecc32MemArea::EccWords &words) {
  std::filebuf fb;
  if (!fb.open(path.c_str(), std::ios::out | std::ios::binary)) {
    std::ostringstream oss;
    oss << "Cannot open the file '" << path << "'.";
    throw std::runtime_error(oss.str());
  }

  for (const Ecc32MemArea::EccWord &word : words) {
    uint8_t bytes[5];

    bool valid = word.first;
    uint32_t w32 = word.second;

    bytes[0] = valid ? 1 : 0;
    for (int j = 0; j < 4; ++j) {
      bytes[j + 1] = (w32 >> (8 * j)) & 0xff;
    }

    std::streamsize chars_out =
        fb.sputn(reinterpret_cast<const char *>(&bytes), 5);
    if (chars_out != 5) {
      std::ostringstream oss;
      oss << "Failed to write to " << path << ".";
      throw std::runtime_error(oss.str());
    }
  }
}

static bool is_xz(svLogic l) { return l == sv_x || l == sv_z; }

template <typename T>
static std::array<T, 32> get_rtl_regs(const std::string &reg_scope) {
  std::array<T, 32> ret;
  static_assert(sizeof(T) <= 256 / 8, "Can only copy 256 bits");

  SVScoped scoped(reg_scope);

  // otbn_rf_peek passes data as a packed array of svBitVecVal words (for a
  // "bit [255:0]" argument). Allocate 256 bits (= 32 bytes) as
  // 32/sizeof(svBitVecVal) words on the stack.
  svBitVecVal buf[256 / 8 / sizeof(svBitVecVal)];

  // The implementation of otbn_rf_peek() is only available if DesignScope != ""
  // (the function is implemented in SystemVerilog, and imported through DPI).
  // We should not reach the code here if that's the case.
  assert(otbn_rf_peek);

  for (int i = 0; i < 32; ++i) {
    if (!otbn_rf_peek(i, buf)) {
      std::ostringstream oss;
      oss << "Failed to peek into RTL to get value of register " << i
          << " at scope `" << reg_scope << "'.";
      throw std::runtime_error(oss.str());
    }
    memcpy(&ret[i], buf, sizeof(T));
  }

  return ret;
}

template <typename T>
static std::vector<T> get_stack(const std::string &stack_scope) {
  std::vector<T> ret;
  static_assert(sizeof(T) <= 256 / 8, "Can only copy 256 bits");

  SVScoped scoped(stack_scope);

  // otbn_stack_element_peek passes data as a packed array of svBitVecVal words
  // (for a "bit [255:0]" argument). Allocate 256 bits (= 32 bytes) as
  // 32/sizeof(svBitVecVal) words on the stack.
  svBitVecVal buf[256 / 8 / sizeof(svBitVecVal)];

  // The implementation of otbn_stack_element_peek() is only available if
  // DesignScope != "" (the function is implemented in SystemVerilog, and
  // imported through DPI).  We should not reach the code here if that's the
  // case.
  assert(otbn_stack_element_peek);

  int i = 0;

  while (1) {
    int peek_result = otbn_stack_element_peek(i, buf);

    // otbn_stack_element_peek is defined in otbn_stack_snooper_if.sv. Possible
    // return values are: 0 on success, if we've returned an element. 1 if the
    // stack doesn't have an element at index i. 2 if something terrible has
    // gone wrong (such as a completely bogus index).
    assert(peek_result <= 2);

    if (peek_result == 2) {
      std::ostringstream oss;
      oss << "Failed to peek into RTL to get value of stack element " << i
          << " at scope `" << stack_scope << "'.";
      throw std::runtime_error(oss.str());
    }

    if (peek_result == 1) {
      // No more elements on stack
      break;
    }

    T stack_element;
    memcpy(&stack_element, buf, sizeof(T));
    ret.push_back(stack_element);

    ++i;
  }

  return ret;
}

OtbnModel::OtbnModel(const std::string &mem_scope,
                     const std::string &design_scope, bool enable_secure_wipe)
    : mem_util_(mem_scope),
      design_scope_(design_scope),
      enable_secure_wipe_(enable_secure_wipe) {}

OtbnModel::~OtbnModel() {}

int OtbnModel::take_loop_warps(const OtbnMemUtil &memutil) {
  ISSWrapper *iss = ensure_wrapper();
  if (!iss)
    return -1;

  try {
    iss->clear_loop_warps();
  } catch (std::runtime_error &err) {
    std::cerr << "Error when clearing loop warps: " << err.what() << "\n";
    return -1;
  }

  for (auto &pr : memutil.GetLoopWarps()) {
    auto &key = pr.first;
    uint32_t addr = key.first;
    uint32_t from_cnt = key.second;
    uint32_t to_cnt = pr.second;

    try {
      iss->add_loop_warp(addr, from_cnt, to_cnt);
    } catch (const std::runtime_error &err) {
      std::cerr << "Error when adding loop warp: " << err.what() << "\n";
      return -1;
    }
  }

  return 0;
}

int OtbnModel::start() {
  const MemArea &imem = mem_util_.GetMemArea(true);

  ISSWrapper *iss = ensure_wrapper();
  if (!iss)
    return -1;

  std::string dfname(iss->make_tmp_path("dmem"));
  std::string ifname(iss->make_tmp_path("imem"));

  try {
    write_words_to_file(dfname, get_sim_memory(false));
    write_words_to_file(ifname, get_sim_memory(true));
  } catch (const std::exception &err) {
    std::cerr << "Error when dumping memory contents: " << err.what() << "\n";
    return -1;
  }

  try {
    iss->load_d(dfname);
    iss->load_i(ifname);
    iss->start();
  } catch (const std::runtime_error &err) {
    std::cerr << "Error when starting ISS: " << err.what() << "\n";
    return -1;
  }

  return 0;
}

void OtbnModel::edn_flush() {
  ISSWrapper *iss = ensure_wrapper();

  iss->edn_flush();
}

void OtbnModel::edn_rnd_step(svLogicVecVal *edn_rnd_data /* logic [31:0] */) {
  ISSWrapper *iss = ensure_wrapper();

  iss->edn_rnd_step(edn_rnd_data->aval);
}

void OtbnModel::edn_urnd_step(svLogicVecVal *edn_urnd_data /* logic [31:0] */) {
  ISSWrapper *iss = ensure_wrapper();

  iss->edn_urnd_step(edn_urnd_data->aval);
}

void OtbnModel::set_keymgr_value(svLogicVecVal *key0 /* logic [383:0] */,
                                 svLogicVecVal *key1 /* logic [383:0] */,
                                 unsigned char valid) {
  ISSWrapper *iss = ensure_wrapper();

  std::array<uint32_t, 12> key0_arr;
  std::array<uint32_t, 12> key1_arr;
  assert(valid == 0 || valid == 1);
  for (int i = 0; i < 12; i++) {
    key0_arr[i] = key0[i].aval;
    key1_arr[i] = key1[i].aval;
  }

  iss->set_keymgr_value(key0_arr, key1_arr, valid != 0);
}

void OtbnModel::edn_urnd_cdc_done() {
  ISSWrapper *iss = ensure_wrapper();
  iss->edn_urnd_cdc_done();
}

void OtbnModel::edn_rnd_cdc_done() {
  ISSWrapper *iss = ensure_wrapper();
  iss->edn_rnd_cdc_done();
}

int OtbnModel::step(svBitVecVal *status /* bit [7:0] */,
                    svBitVecVal *insn_cnt /* bit [31:0] */,
                    svBitVecVal *rnd_req /* bit [0:0] */,
                    svBitVecVal *err_bits /* bit [31:0] */,
                    svBitVecVal *stop_pc /* bit [31:0] */) {
  assert(insn_cnt && err_bits && stop_pc);

  ISSWrapper *iss = ensure_wrapper();
  if (!iss)
    return -1;

  try {
    switch (iss->step(has_rtl())) {
      case -1:
        // Something went wrong, such as a trace mismatch. We've already printed
        // a message to stderr so can just return -1.
        return -1;

      case 1:
        // The simulation has stopped. Fill in status, insn_cnt, err_bits and
        // stop_pc. Note that status should never have anything in its top 24
        // bits.
        if (iss->get_mirrored().status >> 8) {
          throw std::runtime_error("STATUS register had non-empty top bits.");
        }
        set_sv_u8(status, iss->get_mirrored().status);
        svPutBitselBit(rnd_req, 0, (iss->get_mirrored().rnd_req & 1));
        set_sv_u32(insn_cnt, iss->get_mirrored().insn_cnt);
        set_sv_u32(err_bits, iss->get_mirrored().err_bits);
        set_sv_u32(stop_pc, iss->get_mirrored().stop_pc);
        return 1;

      case 0:
        // The simulation is still running. Update status, rnd_req and insn_cnt.
        if (iss->get_mirrored().status >> 8) {
          throw std::runtime_error("STATUS register had non-empty top bits.");
        }
        set_sv_u8(status, iss->get_mirrored().status);
        svPutBitselBit(rnd_req, 0, (iss->get_mirrored().rnd_req & 1));
        set_sv_u32(insn_cnt, iss->get_mirrored().insn_cnt);
        return 0;

      default:
        // This shouldn't happen
        assert(0);
    }
  } catch (const std::runtime_error &err) {
    std::cerr << "Error when stepping ISS: " << err.what() << "\n";
    return -1;
  }
}

int OtbnModel::check() const {
  if (!has_rtl())
    return 1;

  ISSWrapper *iss = iss_.get();
  if (!iss) {
    std::cerr << "Cannot check OTBN model: ISS has not started.\n";
    return -1;
  }

  bool good = true;

  good &= OtbnTraceChecker::get().Finish();

  try {
    good &= check_dmem(*iss);
  } catch (const std::exception &err) {
    std::cerr << "Failed to check DMEM: " << err.what() << "\n";
    return -1;
  }

  try {
    good &= check_regs(*iss);
  } catch (const std::exception &err) {
    std::cerr << "Failed to check registers: " << err.what() << "\n";
    return -1;
  }

  try {
    good &= check_call_stack(*iss);
  } catch (const std::exception &err) {
    std::cerr << "Failed to check call stack: " << err.what() << "\n";
    return -1;
  }

  return good ? 1 : 0;
}

int OtbnModel::load_dmem() {
  ISSWrapper *iss = iss_.get();
  if (!iss) {
    std::cerr << "Cannot load dmem from OTBN model: ISS has not started.\n";
    return -1;
  }

  const MemArea &dmem = mem_util_.GetMemArea(false);

  std::string dfname(iss->make_tmp_path("dmem_out"));
  try {
    // Read DMEM from the ISS
    iss->dump_d(dfname);
    Ecc32MemArea::EccWords words =
        read_words_from_file(dfname, dmem.GetSizeBytes() / 4);
    set_sim_memory(false, words_to_bytes(words));
  } catch (const std::exception &err) {
    std::cerr << "Error when loading dmem from ISS: " << err.what() << "\n";
    return -1;
  }
  return 0;
}

int OtbnModel::invalidate_imem() {
  ISSWrapper *iss = ensure_wrapper();
  if (!iss)
    return -1;

  try {
    iss->invalidate_imem();
  } catch (const std::exception &err) {
    std::cerr << "Error when invalidating IMEM in ISS: " << err.what() << "\n";
    return -1;
  }

  return 0;
}

int OtbnModel::invalidate_dmem() {
  ISSWrapper *iss = ensure_wrapper();
  if (!iss)
    return -1;

  try {
    iss->invalidate_dmem();
  } catch (const std::exception &err) {
    std::cerr << "Error when invalidating DMEM in ISS: " << err.what() << "\n";
    return -1;
  }

  return 0;
}

int OtbnModel::step_crc(const svBitVecVal *item /* bit [47:0] */,
                        svBitVecVal *state /* bit [31:0] */) {
  ISSWrapper *iss = ensure_wrapper();
  if (!iss)
    return -1;

  std::array<uint8_t, 6> item_arr;
  for (int i = 0; i < item_arr.size(); ++i) {
    item_arr[i] = item[i / 4] >> 8 * (i % 4);
  }
  uint32_t state32 = state[0];

  try {
    state32 = iss->step_crc(item_arr, state32);
  } catch (const std::exception &err) {
    std::cerr << "Error when stepping CRC in ISS: " << err.what() << "\n";
    return -1;
  }

  // Write back to SV-land
  state[0] = state32;

  return 0;
}

void OtbnModel::reset() {
  ISSWrapper *iss = iss_.get();
  if (iss)
    iss->reset(has_rtl());
}

int OtbnModel::send_lc_escalation() {
  ISSWrapper *iss = ensure_wrapper();
  if (!iss)
    return -1;

  try {
    iss->send_lc_escalation();
  } catch (const std::exception &err) {
    std::cerr << "Error when sending LC escalation signal to ISS: "
              << err.what() << "\n";
    return -1;
  }

  return 0;
}

ISSWrapper *OtbnModel::ensure_wrapper() {
  if (!iss_) {
    try {
      iss_.reset(new ISSWrapper(enable_secure_wipe_));
    } catch (const std::runtime_error &err) {
      std::cerr << "Error when constructing ISS wrapper: " << err.what()
                << "\n";
      return nullptr;
    }
  }
  assert(iss_);
  return iss_.get();
}

Ecc32MemArea::EccWords OtbnModel::get_sim_memory(bool is_imem) const {
  auto &mem_area = mem_util_.GetMemArea(is_imem);
  return mem_area.ReadWithIntegrity(0, mem_area.GetSizeWords());
}

void OtbnModel::set_sim_memory(bool is_imem, const std::vector<uint8_t> &data) {
  mem_util_.GetMemArea(is_imem).Write(0, data);
}

bool OtbnModel::check_dmem(ISSWrapper &iss) const {
  const MemArea &dmem = mem_util_.GetMemArea(false);
  uint32_t dmem_bytes = dmem.GetSizeBytes();

  std::string dfname(iss.make_tmp_path("dmem_out"));

  iss.dump_d(dfname);
  Ecc32MemArea::EccWords iss_words =
      read_words_from_file(dfname, dmem_bytes / 4);
  assert(iss_words.size() == dmem_bytes / 4);

  Ecc32MemArea::EccWords rtl_words = get_sim_memory(false);
  assert(rtl_words.size() == dmem_bytes / 4);

  std::ios old_state(nullptr);
  old_state.copyfmt(std::cerr);

  int bad_count = 0;
  for (size_t i = 0; i < dmem_bytes / 4; ++i) {
    bool iss_valid = iss_words[i].first;
    bool rtl_valid = rtl_words[i].first;
    uint32_t iss_w32 = iss_words[i].second;
    uint32_t rtl_w32 = rtl_words[i].second;

    // If neither word has valid checksum bits, all is well.
    if (!iss_valid && !rtl_valid)
      continue;

    // If both words have valid checksum bits and equal data, all is well.
    if (iss_valid && rtl_valid && iss_w32 == rtl_w32)
      continue;

    // TODO: At the moment, the ISS doesn't track validity bits properly in
    //       DMEM, which means that we might have a situation where RTL says a
    //       word is invalid, but the ISS doesn't. To avoid spurious failures
    //       until we've implemented things, skip the check in this case. Once
    //       the ISS handles validity bits properly, delete this block.
    if (iss_valid && !rtl_valid)
      continue;

    // Otherwise, something has gone wrong. Print out a banner if this is the
    // first mismatch.
    if (bad_count == 0) {
      std::cerr << "ERROR: Mismatches in dmem data:\n"
                << std::hex << std::setfill('0');
    }

    std::cerr << " @offset 0x" << std::setw(3) << 4 * i << ": ";
    if (iss_valid != rtl_valid) {
      std::cerr << "mismatching validity bits (rtl = " << rtl_valid
                << "; iss = " << iss_valid << ")\n";
    } else {
      assert(iss_valid && rtl_valid && iss_w32 != rtl_w32);
      std::cerr << "rtl has 0x" << std::setw(8) << rtl_w32 << "; iss has 0x"
                << std::setw(8) << iss_w32 << "\n";
    }
    ++bad_count;
    if (bad_count == 10) {
      std::cerr << " (skipping further errors...)\n";
      break;
    }
  }
  std::cerr.copyfmt(old_state);
  return bad_count == 0;
}

bool OtbnModel::check_regs(ISSWrapper &iss) const {
  assert(design_scope_.size());

  std::string base_scope =
      design_scope_ +
      ".u_otbn_rf_base.gen_rf_base_ff.u_otbn_rf_base_inner.u_snooper";
  std::string wide_scope =
      design_scope_ +
      ".u_otbn_rf_bignum.gen_rf_bignum_ff.u_otbn_rf_bignum_inner.u_snooper";

  auto rtl_gprs = get_rtl_regs<uint32_t>(base_scope);
  auto rtl_wdrs = get_rtl_regs<ISSWrapper::u256_t>(wide_scope);

  std::array<uint32_t, 32> iss_gprs;
  std::array<ISSWrapper::u256_t, 32> iss_wdrs;
  iss.get_regs(&iss_gprs, &iss_wdrs);

  bool good = true;

  for (int i = 0; i < 32; ++i) {
    // Register index 1 is call stack, which is checked separately
    if (i == 1)
      continue;

    if (rtl_gprs[i] != iss_gprs[i]) {
      std::ios old_state(nullptr);
      old_state.copyfmt(std::cerr);
      std::cerr << std::setfill('0') << "RTL computed x" << i << " as 0x"
                << std::hex << rtl_gprs[i] << ", but ISS got 0x" << iss_gprs[i]
                << ".\n";
      std::cerr.copyfmt(old_state);
      good = false;
    }
  }
  for (int i = 0; i < 32; ++i) {
    if (0 != memcmp(rtl_wdrs[i].words, iss_wdrs[i].words,
                    sizeof(rtl_wdrs[i].words))) {
      std::ios old_state(nullptr);
      old_state.copyfmt(std::cerr);
      std::cerr << "RTL computed w" << i << " as 0x" << std::hex
                << std::setfill('0');
      for (int j = 0; j < 8; ++j) {
        if (j)
          std::cerr << "_";
        std::cerr << std::setw(8) << rtl_wdrs[i].words[7 - j];
      }
      std::cerr << ", but ISS got 0x";
      for (int j = 0; j < 8; ++j) {
        if (j)
          std::cerr << "_";
        std::cerr << std::setw(8) << iss_wdrs[i].words[7 - j];
      }
      std::cerr << ".\n";
      std::cerr.copyfmt(old_state);
      good = false;
    }
  }

  return good;
}

bool OtbnModel::check_call_stack(ISSWrapper &iss) const {
  assert(design_scope_.size());

  std::string call_stack_snooper_scope =
      design_scope_ + ".u_otbn_rf_base.u_call_stack_snooper";

  auto rtl_call_stack = get_stack<uint32_t>(call_stack_snooper_scope);

  auto iss_call_stack = iss.get_call_stack();

  bool good = true;

  if (iss_call_stack.size() != rtl_call_stack.size()) {
    std::cerr << "Call stack size mismatch, RTL call stack has "
              << rtl_call_stack.size() << " elements and ISS call stack has "
              << iss_call_stack.size() << " elements\n";

    good = false;
  }

  // Iterate through both call stacks where both have elements
  std::size_t call_stack_size =
      std::min(rtl_call_stack.size(), iss_call_stack.size());
  for (std::size_t i = 0; i < call_stack_size; ++i) {
    if (iss_call_stack[i] != rtl_call_stack[i]) {
      std::ios old_state(nullptr);
      old_state.copyfmt(std::cerr);
      std::cerr << std::setfill('0') << "RTL call stack element " << i
                << " is 0x" << std::hex << rtl_call_stack[i]
                << ", but ISS has 0x" << iss_call_stack[i] << ".\n";
      std::cerr.copyfmt(old_state);
      good = false;
    }
  }

  return good;
}

OtbnModel *otbn_model_init(const char *mem_scope, const char *design_scope,
                           int enable_secure_wipe) {
  assert(mem_scope && design_scope);
  assert(enable_secure_wipe == 0 || enable_secure_wipe == 1);
  return new OtbnModel(mem_scope, design_scope, enable_secure_wipe != 0);
}

void otbn_model_destroy(OtbnModel *model) { delete model; }

void edn_model_flush(OtbnModel *model) { model->edn_flush(); }

void edn_model_rnd_step(OtbnModel *model,
                        svLogicVecVal *edn_rnd_data /* logic [31:0] */) {
  model->edn_rnd_step(edn_rnd_data);
}

void edn_model_urnd_step(OtbnModel *model,
                         svLogicVecVal *edn_urnd_data /* logic [31:0] */) {
  model->edn_urnd_step(edn_urnd_data);
}

void edn_model_rnd_cdc_done(OtbnModel *model) { model->edn_rnd_cdc_done(); }

void edn_model_urnd_cdc_done(OtbnModel *model) { model->edn_urnd_cdc_done(); }

unsigned otbn_model_step(OtbnModel *model, svLogic start, unsigned model_state,
                         svBitVecVal *status /* bit [7:0] */,
                         svBitVecVal *insn_cnt /* bit [31:0] */,
                         svBitVecVal *rnd_req /* bit [31:0] */,
                         svBitVecVal *err_bits /* bit [31:0] */,
                         svBitVecVal *stop_pc /* bit [31:0] */) {
  assert(model && status && insn_cnt && err_bits && stop_pc);

  // Run model checks if needed. This usually happens just after an operation
  // has finished.
  if (model->has_rtl() && (model_state & CHECK_DUE_BIT)) {
    switch (model->check()) {
      case 1:
        // Match (success)
        break;

      case 0:
        // Mismatch
        model_state |= FAILED_CMP_BIT;
        break;

      default:
        // Something went wrong
        return (model_state & ~RUNNING_BIT) | FAILED_STEP_BIT;
    }
    model_state &= ~CHECK_DUE_BIT;
  }

  assert(!is_xz(start));

  // Start the model if requested
  if (start) {
    switch (model->start()) {
      case 0:
        // All good
        model_state |= RUNNING_BIT;
        break;

      default:
        // Something went wrong.
        return (model_state & ~RUNNING_BIT) | FAILED_STEP_BIT;
    }
  }

  // Step the model once
  switch (model->step(status, insn_cnt, rnd_req, err_bits, stop_pc)) {
    case 0:
      // Still running: no change
      break;

    case 1:
      // Finished
      model_state = (model_state & ~RUNNING_BIT) | CHECK_DUE_BIT;
      break;

    default:
      // Something went wrong
      return (model_state & ~RUNNING_BIT) | FAILED_STEP_BIT;
  }

  // If we're still running, there's nothing more to do.
  if (model_state & RUNNING_BIT)
    return model_state;

  // If we've just stopped running and there's no RTL, load the contents of
  // DMEM back from the ISS
  if (!model->has_rtl()) {
    switch (model->load_dmem()) {
      case 0:
        // Success
        break;

      default:
        // Failed to load DMEM
        return (model_state & ~RUNNING_BIT) | FAILED_STEP_BIT;
    }
  }

  return model_state;
}

int otbn_model_invalidate_imem(OtbnModel *model) {
  assert(model);
  return model->invalidate_imem();
}

int otbn_model_invalidate_dmem(OtbnModel *model) {
  assert(model);
  return model->invalidate_dmem();
}

int otbn_model_step_crc(OtbnModel *model, svBitVecVal *item /* bit [47:0] */,
                        svBitVecVal *state /* inout bit [31:0] */) {
  assert(model && item && state);
  return model->step_crc(item, state);
}

void otbn_model_reset(OtbnModel *model) {
  assert(model);
  model->reset();
}

void otbn_take_loop_warps(OtbnModel *model, OtbnMemUtil *memutil) {
  assert(model && memutil);
  model->take_loop_warps(*memutil);
}

void otbn_model_set_keymgr_value(OtbnModel *model, svLogicVecVal *key0,
                                 svLogicVecVal *key1, unsigned char valid) {
  assert(model && key0 && key1);
  model->set_keymgr_value(key0, key1, valid);
}

int otbn_model_send_lc_escalation(OtbnModel *model) {
  assert(model);
  return model->send_lc_escalation();
}
