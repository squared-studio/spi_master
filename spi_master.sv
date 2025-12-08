// SPI Master Module (spi_master.sv)
// -----------------------------------------------
// This module serves as the top-level wrapper for the SPI Master core, integrating AXI4-Lite slave
// interface for configuration and control, and managing the SPI communication through a quad-SPI
// interface.
// -----------------------------------------------
// Copyright (c) 2025 Squared Studio
// Author: Foez Ahmed (foez.official@gmail.com)

module spi_master
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

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // SPI Interface
    ////////////////////////////////////////////////////////////////////////////////////////////////

    inout wire           cs_no,
    inout wire           sclk_o,
    inout spi_bus_wire_t sd_io

);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Internal Signals
  //////////////////////////////////////////////////////////////////////////////////////////////////

  spi_bus_logic_t    spi_sdo;
  spi_bus_logic_t    spi_sdi;
  spi_mode_t         spi_mode;
  spi_master_drive_t drive_mode;

  clk_div_t          spi_clk_div;
  logic              divided_clk;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Sub Modules
  //////////////////////////////////////////////////////////////////////////////////////////////////

  spi_master_regif u_regif (
      .arst_ni(arst_ni),
      .clk_i(clk_i),
      .awaddr_i(awaddr_i),
      .awprot_i(awprot_i),
      .awvalid_i(awvalid_i),
      .awready_o(awready_o),
      .wdata_i(wdata_i),
      .wstrb_i(wstrb_i),
      .wvalid_i(wvalid_i),
      .wready_o(wready_o),
      .bresp_o(bresp_o),
      .bvalid_o(bvalid_o),
      .bready_i(bready_i),
      .araddr_i(araddr_i),
      .arprot_i(arprot_i),
      .arvalid_i(arvalid_i),
      .arready_o(arready_o),
      .rdata_o(rdata_o),
      .rresp_o(rresp_o),
      .rvalid_o(rvalid_o),
      .rready_i(rready_i),
      .spi_mode_o(spi_mode)
  );

  spi_master_clk_div u_spi_clk_divider (
      .arst_ni(arst_ni),
      .clk_i  (clk_i),
      .div_i  (spi_clk_div),
      .clk_o  (divided_clk)
  );

  spi_master_phy u_phy (
      .clk_i(divided_clk),
      .spi_sdo(spi_sdo),
      .spi_sdi(spi_sdi),
      .spi_mode_i(spi_mode),
      .drive_mode_i(drive_mode),
      .cs_no(cs_no),
      .sclk_o(sclk_o),
      .sd_io(sd_io)
  );

endmodule
