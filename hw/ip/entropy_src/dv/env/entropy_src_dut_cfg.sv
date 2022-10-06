// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Class to hold register configuration values for the DUT
//
// This class is intended to contain all the dut register configuration values, and their
// corresponding constraints.  Holding these values in a separate class from entropy_src_env_cfg
// allows for clean generation of alternative register configurations, under the same constraints,
// without randomizing any of the other environment config variables typically found in
// entropy_src_env_cfg.
//

class entropy_src_dut_cfg extends uvm_object;

  `uvm_object_utils(entropy_src_dut_cfg)
  `uvm_object_new

  ///////////////////////
  // Constraint knobs  //
  ///////////////////////

  // Constraint knob for module_enable field
  uint          module_enable_pct;

  // Constraint knob for SW-accessible REGWEN-related fields
  uint          me_regwen_pct, sw_regupd_pct;

  // Constraint knobs for Boolean fields in CONF register
  // (RNG_BIT_SEL is always uniform)
  uint          fips_enable_pct, entropy_data_reg_enable_pct, ht_threshold_scope_pct,
                rng_bit_enable_pct;

  // Constraint knobs for Boolean fields in ENTROPY_CONTROL register
  uint          route_software_pct, type_bypass_pct;

  // Constraint knobs for Boolean fields in FW_OV_CONTROL register
  uint          fw_read_pct, fw_over_pct, fw_ov_insert_start_pct;

  // Health test-related knobs
  // Real constraints on sigma ranges (floating point value)
  real adaptp_sigma_max, adaptp_sigma_min;
  real markov_sigma_max, markov_sigma_min;
  real bucket_sigma_max, bucket_sigma_min;

  // Knob to leave thresholds at default, completely disabling them
  uint          default_ht_thresholds_pct;

  // Knob to control frequency of bad settings to MuBi registers or other redundancy fields
  // In order to cleanly test the alert mechanisms, at most one bad field value is allowed
  // per dut configuration.
  // This knob controls the frequency of bad configurations
  uint          bad_mubi_cfg_pct;

  ///////////////////////////////////////////////
  // Fixed DUT configurations (TODO:RANDOMIZE) //
  ///////////////////////////////////////////////

  uint boot_mode_retry_limit;

  ///////////////////////
  // Randomized fields //
  ///////////////////////

  rand bit                      sw_regupd, me_regwen;
  rand bit [1:0]                rng_bit_sel;

  rand prim_mubi_pkg::mubi4_t   module_enable, fips_enable, route_software, type_bypass,
                                entropy_data_reg_enable, rng_bit_enable, ht_threshold_scope;

  rand int                      observe_fifo_thresh;

  rand int                      fips_window_size, bypass_window_size;

  rand bit [15:0]               alert_threshold;
  rand bit [15:0]               alert_threshold_inv;

  rand prim_mubi_pkg::mubi4_t   fw_read_enable, fw_over_enable, fw_ov_insert_start;

  // Note: These integer-valued fields are used to derive their real-valued counterparts.
  rand int unsigned adaptp_sigma_i, markov_sigma_i, bucket_sigma_i;

  // Randomized real values: to be managed in post_randomize
  // Controlled by the knobs <test>_sigma_max, <test>_sigma_min
  real              adaptp_sigma, markov_sigma, bucket_sigma;

  // Thresholds for repcnt repcnts
  rand bit [15:0]   repcnt_thresh_bypass, repcnt_thresh_fips,
                    repcnts_thresh_bypass, repcnts_thresh_fips;

  // Bit to leave thresholds at default values (effectively disabling HTs)
  rand int          default_ht_thresholds;

  rand bit             use_invalid_mubi;
  rand invalid_mubi_e  which_invalid_mubi;

  /////////////////
  // Constraints //
  /////////////////

  constraint bypass_window_size_c { bypass_window_size dist {
      384 :/ 1 };}

  constraint fips_window_size_c { fips_window_size dist {
     512  :/ 1,
     1024 :/ 1,
     2048 :/ 5,
     4096 :/ 1,
     8192 :/ 1 };}

  constraint sw_regupd_c {sw_regupd dist {
      1 :/ sw_regupd_pct,
      0 :/ (100 - sw_regupd_pct) };}

  constraint me_regwen_c {me_regwen dist {
      1 :/ me_regwen_pct,
      0 :/ (100 - me_regwen_pct) };}

  constraint fw_read_enable_c {fw_read_enable dist {
      prim_mubi_pkg::MuBi4True  :/ fw_read_pct,
      prim_mubi_pkg::MuBi4False :/ (100 - fw_read_pct) };}

  constraint fw_over_enable_c {fw_over_enable dist {
      prim_mubi_pkg::MuBi4True  :/ fw_over_pct,
      prim_mubi_pkg::MuBi4False :/ (100 - fw_over_pct) };}

  constraint fw_ov_insert_start_c {fw_ov_insert_start dist {
      prim_mubi_pkg::MuBi4True  :/ fw_ov_insert_start_pct,
      prim_mubi_pkg::MuBi4False :/ (100 - fw_ov_insert_start_pct) };}

  constraint module_enable_c {module_enable dist {
      prim_mubi_pkg::MuBi4True  :/ module_enable_pct,
      prim_mubi_pkg::MuBi4False :/ (100 - module_enable_pct) };}

  constraint fips_enable_c {fips_enable dist {
      prim_mubi_pkg::MuBi4True  :/ fips_enable_pct,
      prim_mubi_pkg::MuBi4False :/ (100 - fips_enable_pct) };}

  constraint route_c {route_software dist {
      prim_mubi_pkg::MuBi4True  :/ route_software_pct,
      prim_mubi_pkg::MuBi4False :/ (100 - route_software_pct) };}

  constraint bypass_c {type_bypass dist {
      prim_mubi_pkg::MuBi4True  :/ type_bypass_pct,
      prim_mubi_pkg::MuBi4False :/ (100 - type_bypass_pct) };}

  constraint entropy_data_reg_enable_c {entropy_data_reg_enable dist {
      prim_mubi_pkg::MuBi4True  :/ entropy_data_reg_enable_pct,
      prim_mubi_pkg::MuBi4False :/ (100 - entropy_data_reg_enable_pct) };}

  constraint rng_bit_enable_c {rng_bit_enable dist {
      prim_mubi_pkg::MuBi4True  :/ rng_bit_enable_pct,
      prim_mubi_pkg::MuBi4False :/ (100 - rng_bit_enable_pct) };}

  constraint ht_threshold_scope_c {ht_threshold_scope dist {
      prim_mubi_pkg::MuBi4True  :/ ht_threshold_scope_pct,
      prim_mubi_pkg::MuBi4False :/ (100 - ht_threshold_scope_pct)};}

  // Bins arranged according to likelihood of false positive for the REPCNT test
  // 6-10: > 1 in 1024 chance of a false positive (fairly likely, great for abusive tests)
  // 10-20: > 1 in 2^20 false positive chance. (More rare, and overly conservative thresholding
  //        even by NIST SP800-90B standards)
  // 20-40: Typical acceptable range of NIST thresholds assuming a near-ideal RNG source
  //        (false positive rate > 1 in 2^40)
  // > 40:  Threshold is weaker than NIST standards (unless there is some known statistical defect
  //        in the RNG source which means that the false positive rate is still > 1 in 2^40)
  //
  // The last bin captures this most relaxed
  //
  // TODO: Establish usable constraints for repcnt thresholds < 40
  // Temporarily disable the tighter bins, to allow seeds to pass.  The previous bins were
  // previously so tight that no seed outputs were ever observed.  Even though each individual HT
  // may pass with reasonable probability, if multiple HT thresholds are set tightly, the
  // probability of all passing approaches zero, and we never see any entropy outputs.
  constraint repcnt_thresh_bypass_c {repcnt_thresh_bypass dist {
      [6  : 10] :/ 0,
      [11 : 20] :/ 0,
      [21 : 40] :/ 0,
      41        :/ 10};}

  // TODO: Establish usable constraints for repcnt thresholds < 40
  // See similar TODO note above for further details
  constraint repcnt_thresh_fips_c {repcnt_thresh_fips dist {
      [6  : 10] :/ 0,
      [11 : 20] :/ 0,
      [21 : 40] :/ 0,
      41        :/ 10};}

  // Make the bin sizes for the repcnts test 1/4 as small as the corresponding repcnt bins sizes,
  // since the likelihood of coincidental
  // failure is comparable to that of gathering 4x more data with the repcnt
  // test.
  //
  // As with the repcnt test, the highest bin would (for an assumed ideal RNG noice source)

  // TODO: Establish usable constraints for repcnts thresholds < 10
  // See similar TODO note above for further details
  constraint repcnts_thresh_bypass_c {repcnts_thresh_bypass dist {
      [2  :  3] :/ 0,
      [4  :  5] :/ 0,
      [6  : 10] :/ 0,
      11       :/ 10};}

  // TODO: Establish usable constraints for repcnts thresholds < 10
  // See similar TODO note above for further details
  constraint repcnts_thresh_fips_c {repcnts_thresh_fips dist {
      [2  :  3] :/ 0,
      [4  :  5] :/ 0,
      [6  : 10] :/ 0,
      [11 : 80] :/ 10};}

  // TODO: Update dist to satisfy cover points
  constraint alert_threshold_c {alert_threshold dist {
      1 :/ 2,
      2 :/ 5,
      3 :/ 1,
      4 :/ 1};}

  constraint default_ht_thresholds_c {default_ht_thresholds dist {
      1 :/ default_ht_thresholds_pct,
      0 :/ (100 - default_ht_thresholds_pct)};}

  constraint use_invalid_mubi_c {use_invalid_mubi dist {
      1 :/ bad_mubi_cfg_pct,
      0 :/ (100 - bad_mubi_cfg_pct)};}

  // TODO: Is zero a valid value for this register?
  // What does the DUT do with a value of zero?
  constraint observe_fifo_thresh_c {observe_fifo_thresh dist {
      [1:OBSERVE_FIFO_DEPTH]  :/ 1};}

  ///////////////
  // Functions //
  ///////////////

  virtual function string convert2string();
    string str = "";
    str = {str, "\n"};
    str = {str, "\n\t |**************** entropy_src_dut_cfg *****************| \t"};

    str = {
        str,
        $sformatf("\n\t |***** module_enable               : %12s *****| \t",
                  module_enable.name()),
        $sformatf("\n\t |***** fips_enable                 : %12s *****| \t",
                  fips_enable.name()),
        $sformatf("\n\t |***** route_software              : %12s *****| \t",
                  route_software.name()),
        $sformatf("\n\t |***** type_bypass                 : %12s *****| \t",
                  type_bypass.name()),
        $sformatf("\n\t |***** entropy_data_reg_enable     : %12s *****| \t",
                  entropy_data_reg_enable.name()),
        $sformatf("\n\t |***** rng_bit_enable              : %12s *****| \t",
                  rng_bit_enable.name()),
        $sformatf("\n\t |***** rng_bit_sel                 : %12d *****| \t",
                  rng_bit_sel),
        $sformatf("\n\t |***** fips_window_size            : %12d *****| \t",
                  fips_window_size),
        $sformatf("\n\t |***** bypass_window_size          : %12d *****| \t",
                  bypass_window_size),
        $sformatf("\n\t |***** boot_mode_retry_limit       : %12d *****| \t",
                  boot_mode_retry_limit),
        $sformatf("\n\t |***** fw_read_enable              : %12s *****| \t",
                  fw_read_enable.name()),
        $sformatf("\n\t |***** fw_over_enable              : %12s *****| \t",
                  fw_over_enable.name()),
        $sformatf("\n\t |***** observe_fifo_threshold      : %12d *****| \t",
                  observe_fifo_thresh),
        $sformatf("\n\t |***** adaptp_sigma                : %12.3f *****| \t",
                  adaptp_sigma),
        $sformatf("\n\t |***** bucket_sigma                : %12.3f *****| \t",
                  bucket_sigma),
        $sformatf("\n\t |***** markov_sigma                : %12.3f *****| \t",
                  markov_sigma)
    };

    str = {str, "\n\t |----------------- knobs ------------------------------| \t"};

    str = {
        str,
        $sformatf("\n\t |***** fw_read_pct                 : %12d *****| \t",
                  fw_read_pct),
        $sformatf("\n\t |***** fw_over_pct                 : %12d *****| \t",
                  fw_over_pct),
        $sformatf("\n\t |***** module_enable_pct           : %12d *****| \t",
                  module_enable_pct),
        $sformatf("\n\t |***** fips_enable_pct             : %12d *****| \t",
                  fips_enable_pct),
        $sformatf("\n\t |***** route_software_pct          : %12d *****| \t",
                  route_software_pct),
        $sformatf("\n\t |***** type_bypass_pct             : %12d *****| \t",
                  type_bypass_pct),
        $sformatf("\n\t |***** entropy_data_reg_enable_pct : %12d *****| \t",
                  entropy_data_reg_enable_pct),
        $sformatf("\n\t |***** rng_bit_enable_pct          : %12d *****| \t",
                  rng_bit_enable_pct),
        $sformatf("\n\t |***** adaptp_sigma range          : (%04.2f, %04.2f) *****| \t",
                  adaptp_sigma_min, adaptp_sigma_max),
        $sformatf("\n\t |***** bucket_sigma range          : (%04.2f, %04.2f) *****| \t",
                  bucket_sigma_min, bucket_sigma_max),
        $sformatf("\n\t |***** markov_sigma range          : (%04.2f, %04.2f) *****| \t",
                  markov_sigma_min, markov_sigma_max)
    };

    str = {str, "\n\t |******************************************************| \t"};
    str = {str, "\n"};

    return str;
  endfunction

  function void post_randomize();
    // temporary variable to map randomized integer variables to the range [0, 1]
    real tmp_r;
    bit bad_alert_threshold_inv = 0;

    tmp_r = real'(adaptp_sigma_i)/{$bits(adaptp_sigma_i){1'b1}};
    adaptp_sigma = adaptp_sigma_min + (adaptp_sigma_max - adaptp_sigma_min) * tmp_r;

    tmp_r = real'(markov_sigma_i)/{$bits(markov_sigma_i){1'b1}};
    markov_sigma = markov_sigma_min + (markov_sigma_max - markov_sigma_min) * tmp_r;

    tmp_r = real'(bucket_sigma_i)/{$bits(bucket_sigma_i){1'b1}};
    bucket_sigma = bucket_sigma_min + (bucket_sigma_max - bucket_sigma_min) * tmp_r;

    if (use_invalid_mubi) begin
      prim_mubi_pkg::mubi4_t invalid_mubi_val;

      invalid_mubi_val = get_rand_mubi4_val(.t_weight(0), .f_weight(0), .other_weight(1));

      case (which_invalid_mubi)
        invalid_fips_enable: fips_enable = invalid_mubi_val;
        invalid_entropy_data_reg_enable: entropy_data_reg_enable = invalid_mubi_val;
        invalid_module_enable: module_enable = invalid_mubi_val;
        invalid_threshold_scope: ht_threshold_scope = invalid_mubi_val;
        invalid_rng_bit_enable: rng_bit_enable = invalid_mubi_val;
        invalid_fw_ov_mode: fw_read_enable = invalid_mubi_val;
        invalid_fw_ov_entropy_insert: fw_over_enable = invalid_mubi_val;
        invalid_fw_ov_insert_start: fw_ov_insert_start = invalid_mubi_val;
        invalid_es_route: route_software = invalid_mubi_val;
        invalid_es_type: type_bypass = invalid_mubi_val;
        invalid_alert_threshold: begin
          // Let the alert_threshold_inv field take some
          // improper value.
          bad_alert_threshold_inv = 1;
        end
        default: begin
          `uvm_fatal(`gfn, "Invalid case! (bug in environment)")
        end
      endcase // case (which_invalid_mubi)
    end

    if (!bad_alert_threshold_inv) begin
      alert_threshold_inv = ~alert_threshold;
    end else if (alert_threshold_inv == ~alert_threshold) begin
      // In the unlikely event that the random value of alert_threshold_inv satisfies
      // our inverse condition force it a known unacceptable value
      alert_threshold_inv = (alert_threshold == 0) ? 16'h1 : alert_threshold;
    end
  endfunction

endclass
