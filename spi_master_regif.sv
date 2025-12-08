// SPI Master Register Interface (spi_master_regif.sv)
// -----------------------------------------------
// This module implements the AXI4-Lite slave register interface for the SPI Master core.
// -----------------------------------------------
// Copyright (c) 2025 Squared Studio
// Author: Foez Ahmed (foez.official@gmail.com)

module spi_master_regif
  import spi_master_pkg::*;
(

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Global Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    input logic arst_ni,
    input logic clk_i,

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // AXI4-Lite Slave Interface
    ////////////////////////////////////////////////////////////////////////////////////////////////

    input  addr_t awaddr_i,
    input  prot_t awprot_i,
    input  logic  awvalid_i,
    output logic  awready_o,

    input  data_t wdata_i,
    input  strb_t wstrb_i,
    input  logic  wvalid_i,
    output logic  wready_o,

    output resp_t bresp_o,
    output logic  bvalid_o,
    input  logic  bready_i,

    input  addr_t araddr_i,
    input  prot_t arprot_i,
    input  logic  arvalid_i,
    output logic  arready_o,

    output data_t rdata_o,
    output resp_t rresp_o,
    output logic  rvalid_o,
    input  logic  rready_i,

    output spi_mode_t spi_mode_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Registers
  //////////////////////////////////////////////////////////////////////////////////////////////////

  spi_mode_t spi_mode;
  addr_t     csr_base_addr;
  addr_t     csr_high_addr;
  addr_t     mem_base_addr;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Assign Outputs
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign spi_mode_o = spi_mode;

endmodule
