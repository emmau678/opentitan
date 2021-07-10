// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Wrapper functions for SRAM's encrypted read/write operations.
// This file is included in `mem_bkdr_util.sv` as a continuation of `mem_bkdr_util` class.

virtual function logic [7:0] sram_encrypt_read8(logic [bus_params_pkg::BUS_AW-1:0] addr,
                                                logic [SRAM_KEY_WIDTH-1:0]         key,
                                                logic [SRAM_BLOCK_WIDTH-1:0]       nonce);
  logic [bus_params_pkg::BUS_AW-1:0] bus_addr = '0;
  logic [7:0]                        rdata = '0;

  logic rdata_arr     [] = new[8];
  logic scrambled_addr[] = new[addr_width];
  logic sram_addr     [] = new[addr_width];
  logic key_arr       [] = new[SRAM_KEY_WIDTH];
  logic nonce_arr     [] = new[SRAM_BLOCK_WIDTH];

  key_arr   = {<<{key}};
  nonce_arr = {<<{nonce}};

  for (int i = 0; i < addr_width; i++) begin
    sram_addr[i] = addr[addr_lsb + i];
  end

  // Calculate the scrambled address
  scrambled_addr = sram_scrambler_pkg::encrypt_sram_addr(sram_addr, addr_width, nonce_arr);

  // Construct bus representation of the address
  for (int i = 0; i < addr_lsb; i++) begin
    bus_addr[i] = addr[i];
  end
  for (int i = 0; i < addr_width; i++) begin
    bus_addr[addr_lsb + i] = scrambled_addr[i];
  end

  // Read memory, and return the decrypted data
  rdata = read8(bus_addr);
  rdata_arr = {<<{rdata}};
  rdata_arr = sram_scrambler_pkg::decrypt_sram_data(
      rdata_arr, 8, sram_addr, addr_width, key_arr, nonce_arr
  );
  rdata = {<<{rdata_arr}};
  return rdata;
endfunction

virtual function logic [15:0] sram_encrypt_read16(logic [bus_params_pkg::BUS_AW-1:0] addr,
                                                  logic [SRAM_KEY_WIDTH-1:0]         key,
                                                  logic [SRAM_BLOCK_WIDTH-1:0]       nonce);
  logic [bus_params_pkg::BUS_AW-1:0] bus_addr = '0;
  logic [15:0]                       rdata = '0;

  logic rdata_arr     [] = new[16];
  logic scrambled_addr[] = new[addr_width];
  logic sram_addr     [] = new[addr_width];
  logic key_arr       [] = new[SRAM_KEY_WIDTH];
  logic nonce_arr     [] = new[SRAM_BLOCK_WIDTH];

  key_arr   = {<<{key}};
  nonce_arr = {<<{nonce}};

  for (int i = 0; i < addr_width; i++) begin
    sram_addr[i] = addr[addr_lsb + i];
  end

  // Calculate the scrambled address
  scrambled_addr = sram_scrambler_pkg::encrypt_sram_addr(sram_addr, addr_width, nonce_arr);

  // Construct bus representation of the address
  for (int i = 0; i < addr_lsb; i++) begin
    bus_addr[i] = addr[i];
  end
  for (int i = 0; i < addr_width; i++) begin
    bus_addr[addr_lsb + i] = scrambled_addr[i];
  end

  // Read memory and return the decrypted data
  rdata = read16(bus_addr);
  rdata_arr = {<<{rdata}};
  rdata_arr = sram_scrambler_pkg::decrypt_sram_data(
      rdata_arr, 16, sram_addr, addr_width, key_arr, nonce_arr
  );
  rdata = {<<{rdata_arr}};
  return rdata;
endfunction

virtual function logic [31:0] sram_encrypt_read32(logic [bus_params_pkg::BUS_AW-1:0] addr,
                                                  logic [SRAM_KEY_WIDTH-1:0]         key,
                                                  logic [SRAM_BLOCK_WIDTH-1:0]       nonce);
  logic [bus_params_pkg::BUS_AW-1:0] bus_addr = '0;
  logic [31:0]                       rdata = '0;

  logic rdata_arr     [] = new[32];
  logic scrambled_addr[] = new[addr_width];
  logic sram_addr     [] = new[addr_width];
  logic key_arr       [] = new[SRAM_KEY_WIDTH];
  logic nonce_arr     [] = new[SRAM_BLOCK_WIDTH];

  key_arr   = {<<{key}};
  nonce_arr = {<<{nonce}};
  for (int i = 0; i < addr_width; i++) begin
    sram_addr[i] = addr[addr_lsb + i];
  end

  // Calculate the scrambled address
  scrambled_addr = sram_scrambler_pkg::encrypt_sram_addr(sram_addr, addr_width, nonce_arr);

  // Construct bus representation of the address
  for (int i = 0; i < addr_lsb; i++) begin
    bus_addr[i] = addr[i];
  end
  for (int i = 0; i < addr_width; i++) begin
    bus_addr[addr_lsb + i] = scrambled_addr[i];
  end

  // Read memory and return the decrypted data
  rdata = read32(bus_addr);
  rdata_arr = {<<{rdata}};
  rdata_arr = sram_scrambler_pkg::decrypt_sram_data(
      rdata_arr, 32, sram_addr, addr_width, key_arr, nonce_arr
  );
  rdata = {<<{rdata_arr}};
  return rdata;

endfunction

virtual function logic [63:0] sram_encrypt_read64(logic [bus_params_pkg::BUS_AW-1:0] addr,
                                                  logic [SRAM_KEY_WIDTH-1:0]         key,
                                                  logic [SRAM_BLOCK_WIDTH-1:0]       nonce);
  logic [bus_params_pkg::BUS_AW-1:0] bus_addr = '0;
  logic [63:0]                       rdata = '0;

  logic rdata_arr     [] = new[64];
  logic scrambled_addr[] = new[addr_width];
  logic sram_addr     [] = new[addr_width];
  logic key_arr       [] = new[SRAM_KEY_WIDTH];
  logic nonce_arr     [] = new[SRAM_BLOCK_WIDTH];

  key_arr   = {<<{key}};
  nonce_arr = {<<{nonce}};

  for (int i = 0; i < addr_width; i++) begin
    sram_addr[i] = addr[addr_lsb + i];
  end

  // Calculate the scrambled address
  scrambled_addr = sram_scrambler_pkg::encrypt_sram_addr(sram_addr, addr_width, nonce_arr);

  // Construct bus representation of the address
  for (int i = 0; i < addr_lsb; i++) begin
    bus_addr[i] = addr[i];
  end
  for (int i = 0; i < addr_width; i++) begin
    bus_addr[addr_lsb + i] = scrambled_addr[i];
  end

  // Read memory and return the decrypted data
  rdata = read64(bus_addr);
  rdata_arr = {<<{rdata}};
  rdata_arr = sram_scrambler_pkg::decrypt_sram_data(
      rdata_arr, 64, sram_addr, addr_width, key_arr, nonce_arr
  );
  rdata = {<<{rdata_arr}};
  return rdata;

endfunction

virtual function void sram_encrypt_write8(logic [bus_params_pkg::BUS_AW-1:0] addr,
                                          logic [7:0]                        data,
                                          logic [SRAM_KEY_WIDTH-1:0]         key,
                                          logic [SRAM_BLOCK_WIDTH-1:0]       nonce);
  logic [bus_params_pkg::BUS_AW-1:0] bus_addr = '0;
  logic [7:0]                        scrambled_data;

  logic wdata_arr      [] = new[8];
  logic scrambled_addr [] = new[addr_width];
  logic sram_addr      [] = new[addr_width];
  logic key_arr        [] = new[SRAM_KEY_WIDTH];
  logic nonce_arr      [] = new[SRAM_BLOCK_WIDTH];

  key_arr   = {<<{key}};
  nonce_arr = {<<{nonce}};

  for (int i = 0; i < addr_width; i++) begin
    sram_addr[i] = addr[addr_lsb + i];
  end

  // Calculate the scrambled address
  scrambled_addr = sram_scrambler_pkg::encrypt_sram_addr(sram_addr, addr_width, nonce_arr);

  // Calculate the scrambled data
  wdata_arr = {<<{data}};
  wdata_arr = sram_scrambler_pkg::encrypt_sram_data(
      wdata_arr, 8, sram_addr, addr_width, key_arr, nonce_arr
  );
  scrambled_data = {<<{wdata_arr}};

  // Construct bus representation of the address
  for (int i = 0; i < addr_lsb; i++) begin
    bus_addr[i] = addr[i];
  end
  for (int i = 0; i < addr_width; i++) begin
    bus_addr[addr_lsb + i] = scrambled_addr[i];
  end

  // Write the scrambled data to memory
  write8(bus_addr, scrambled_data);
endfunction

virtual function void sram_encrypt_write16(logic [bus_params_pkg::BUS_AW-1:0] addr,
                                           logic [15:0]                       data,
                                           logic [SRAM_KEY_WIDTH-1:0]         key,
                                           logic [SRAM_BLOCK_WIDTH-1:0]       nonce);
  logic [bus_params_pkg::BUS_AW-1:0] bus_addr = '0;
  logic [15:0]                       scrambled_data;

  logic wdata_arr      [] = new[16];
  logic scrambled_addr [] = new[addr_width];
  logic sram_addr      [] = new[addr_width];
  logic key_arr        [] = new[SRAM_KEY_WIDTH];
  logic nonce_arr      [] = new[SRAM_BLOCK_WIDTH];

  key_arr   = {<<{key}};
  nonce_arr = {<<{nonce}};

  for (int i = 0; i < addr_width; i++) begin
    sram_addr[i] = addr[addr_lsb + i];
  end

  // Calculate the scrambled address
  scrambled_addr = sram_scrambler_pkg::encrypt_sram_addr(sram_addr, addr_width, nonce_arr);

  // Calculate the scrambled data
  wdata_arr = {<<{data}};
  wdata_arr = sram_scrambler_pkg::encrypt_sram_data(
      wdata_arr, 16, sram_addr, addr_width, key_arr, nonce_arr
  );
  scrambled_data = {<<{wdata_arr}};

  // Construct bus representation of the address
  for (int i = 0; i < addr_lsb; i++) begin
    bus_addr[i] = addr[i];
  end
  for (int i = 0; i < addr_width; i++) begin
    bus_addr[addr_lsb + i] = scrambled_addr[i];
  end

  // Write the scrambled data to memory
  write16(bus_addr, scrambled_data);
endfunction

virtual function void sram_encrypt_write32(logic [bus_params_pkg::BUS_AW-1:0] addr,
                                           logic [31:0]                       data,
                                           logic [SRAM_KEY_WIDTH-1:0]         key,
                                           logic [SRAM_BLOCK_WIDTH-1:0]       nonce);
  logic [bus_params_pkg::BUS_AW-1:0] bus_addr = '0;
  logic [31:0]                       scrambled_data;

  logic wdata_arr      [] = new[32];
  logic scrambled_addr [] = new[addr_width];
  logic sram_addr      [] = new[addr_width];
  logic key_arr        [] = new[SRAM_KEY_WIDTH];
  logic nonce_arr      [] = new[SRAM_BLOCK_WIDTH];

  key_arr   = {<<{key}};
  nonce_arr = {<<{nonce}};

  for (int i = 0; i < addr_width; i++) begin
    sram_addr[i] = addr[addr_lsb + i];
  end

  // Calculate the scrambled address
  scrambled_addr = sram_scrambler_pkg::encrypt_sram_addr(sram_addr, addr_width, nonce_arr);

  // Calculate the scrambled data
  wdata_arr = {<<{data}};
  wdata_arr = sram_scrambler_pkg::encrypt_sram_data(
      wdata_arr, 32, sram_addr, addr_width, key_arr, nonce_arr
  );
  scrambled_data = {<<{wdata_arr}};

  // Construct bus representation of the address
  for (int i = 0; i < addr_lsb; i++) begin
    bus_addr[i] = addr[i];
  end
  for (int i = 0; i < addr_width; i++) begin
    bus_addr[addr_lsb + i] = scrambled_addr[i];
  end

  // Write the scrambled data to memory
  write32(bus_addr, scrambled_data);
endfunction

virtual function void sram_encrypt_write64(logic [bus_params_pkg::BUS_AW-1:0] addr,
                                           logic [63:0]                       data,
                                           logic [SRAM_KEY_WIDTH-1:0]         key,
                                           logic [SRAM_BLOCK_WIDTH-1:0]       nonce);
  logic [bus_params_pkg::BUS_AW-1:0] bus_addr = '0;
  logic [63:0]                       scrambled_data;

  logic wdata_arr      [] = new[64];
  logic scrambled_addr [] = new[addr_width];
  logic sram_addr      [] = new[addr_width];
  logic key_arr        [] = new[SRAM_KEY_WIDTH];
  logic nonce_arr      [] = new[SRAM_BLOCK_WIDTH];

  key_arr   = {<<{key}};
  nonce_arr = {<<{nonce}};

  for (int i = 0; i < addr_width; i++) begin
    sram_addr[i] = addr[addr_lsb + i];
  end

  // Calculate the scrambled address
  scrambled_addr = sram_scrambler_pkg::encrypt_sram_addr(sram_addr, addr_width, nonce_arr);

  // Calculate the scrambled data
  wdata_arr = {<<{data}};
  wdata_arr = sram_scrambler_pkg::encrypt_sram_data(
      wdata_arr, 64, sram_addr, addr_width, key_arr, nonce_arr
  );
  scrambled_data = {<<{wdata_arr}};

  // Construct bus representation of the address
  for (int i = 0; i < addr_lsb; i++) begin
    bus_addr[i] = addr[i];
  end
  for (int i = 0; i < addr_width; i++) begin
    bus_addr[addr_lsb + i] = scrambled_addr[i];
  end

  // Write the scrambled data to memory
  write64(bus_addr, scrambled_data);
endfunction
