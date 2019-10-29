// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// TL-UL fifo, used to add elasticity or an asynchronous clock crossing
// to an TL-UL bus.  This instantiates two FIFOs, one for the request side,
// and one for the response side.

module tlul_fifo_sync #(
  parameter ReqPass  = 1'b1,
  parameter RspPass  = 1'b1,
  parameter ReqDepth = 2,     // maximum allowed depth == 8 (TODO: assertions)
  parameter RspDepth = 2,     // maximum allowed depth == 8 (TODO: assertions)
  parameter SpareReqW = 1,
  parameter SpareRspW = 1
) (
  input                     clk_i,
  input                     rst_ni,
  input  tlul_pkg::tl_h2d_t tl_h_i,
  output tlul_pkg::tl_d2h_t tl_h_o,
  output tlul_pkg::tl_h2d_t tl_d_o,
  input  tlul_pkg::tl_d2h_t tl_d_i,
  input  [SpareReqW-1:0]    spare_req_i,
  output [SpareReqW-1:0]    spare_req_o,
  input  [SpareRspW-1:0]    spare_rsp_i,
  output [SpareRspW-1:0]    spare_rsp_o
);

  // Put everything on the request side into one FIFO
  localparam REQFIFO_WIDTH = $bits(tlul_pkg::tl_h2d_t) -2 + SpareReqW;

  prim_fifo_sync #(.Width(REQFIFO_WIDTH), .Pass(ReqPass), .Depth(ReqDepth)) reqfifo (
    .clk_i,
    .rst_ni,
    .clr_i         (1'b0          ),
    .wvalid        (tl_h_i.a_valid),
    .wready        (tl_h_o.a_ready),
    .wdata         ({tl_h_i.a_opcode ,
                     tl_h_i.a_param  ,
                     tl_h_i.a_size   ,
                     tl_h_i.a_source ,
                     tl_h_i.a_address,
                     tl_h_i.a_mask   ,
                     tl_h_i.a_data   ,
                     tl_h_i.a_user   ,
                     spare_req_i}),
    .depth         (),
    .rvalid        (tl_d_o.a_valid),
    .rready        (tl_d_i.a_ready),
    .rdata         ({tl_d_o.a_opcode ,
                     tl_d_o.a_param  ,
                     tl_d_o.a_size   ,
                     tl_d_o.a_source ,
                     tl_d_o.a_address,
                     tl_d_o.a_mask   ,
                     tl_d_o.a_data   ,
                     tl_d_o.a_user   ,
                     spare_req_o}));

  // Put everything on the response side into the other FIFO

  localparam RSPFIFO_WIDTH = $bits(tlul_pkg::tl_d2h_t) -2 + SpareRspW;

  prim_fifo_sync #(.Width(RSPFIFO_WIDTH), .Pass(RspPass), .Depth(RspDepth)) rspfifo (
    .clk_i,
    .rst_ni,
    .clr_i         (1'b0          ),
    .wvalid        (tl_d_i.d_valid),
    .wready        (tl_d_o.d_ready),
    .wdata         ({tl_d_i.d_opcode,
                     tl_d_i.d_param ,
                     tl_d_i.d_size  ,
                     tl_d_i.d_source,
                     tl_d_i.d_sink  ,
                     tl_d_i.d_data  ,
                     tl_d_i.d_user  ,
                     tl_d_i.d_error ,
                     spare_rsp_i}),
    .depth         (),
    .rvalid        (tl_h_o.d_valid),
    .rready        (tl_h_i.d_ready),
    .rdata         ({tl_h_o.d_opcode,
                     tl_h_o.d_param ,
                     tl_h_o.d_size  ,
                     tl_h_o.d_source,
                     tl_h_o.d_sink  ,
                     tl_h_o.d_data  ,
                     tl_h_o.d_user  ,
                     tl_h_o.d_error ,
                     spare_rsp_o}));

endmodule
