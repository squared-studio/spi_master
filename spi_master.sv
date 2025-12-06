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
#(
    parameter  int ADDR_WIDTH = 32,
    parameter  int DATA_WIDTH = 32,
    localparam int NUM_WIRES  = 4
) (

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Global Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    input logic arst_ni,
    input logic system_clk_i,

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // AXI4-Lite Slave Interface
    ////////////////////////////////////////////////////////////////////////////////////////////////

    input  logic [ADDR_WIDTH-1:0] awaddr_i,
    input  logic [           2:0] awprot_i,
    input  logic                  awvalid_i,
    output logic                  awready_o,

    input  logic [    DATA_WIDTH-1:0] wdata_i,
    input  logic [(DATA_WIDTH/8)-1:0] wstrb_i,
    input  logic                      wvalid_i,
    output logic                      wready_o,

    output logic [1:0] bresp_o,
    output logic       bvalid_o,
    input  logic       bready_i,

    input  logic [ADDR_WIDTH-1:0] araddr_i,
    input  logic [           2:0] arprot_i,
    input  logic                  arvalid_i,
    output logic                  arready_o,

    output logic [DATA_WIDTH-1:0] rdata_o,
    output logic [           1:0] rresp_o,
    output logic                  rvalid_o,
    input  logic                  rready_i,

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // SPI Interface
    ////////////////////////////////////////////////////////////////////////////////////////////////

    inout wire                 cs_no,
    inout wire                 sclk_o,
    inout wire [NUM_WIRES-1:0] sd_io

);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Imports
  //////////////////////////////////////////////////////////////////////////////////////////////////


  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Type Definitions
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Internal Signals
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic              [NUM_WIRES-1:0] spi_sdo;
  logic              [NUM_WIRES-1:0] spi_sdo_en;
  logic              [NUM_WIRES-1:0] spi_sdi;

  spi_mode_t                         spi_mode;
  spi_master_drive_e                 drive_mode;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Combinational Logic
  //////////////////////////////////////////////////////////////////////////////////////////////////

  spi_master_phy#(
      .NUM_WIRES(NUM_WIRES)
  ) (
      .spi_sdo(spi_sdo),
      .spi_sdo_en(spi_sdo_en),
      .spi_sdi(spi_sdi),
      .spi_mode_i(spi_mode),
      .drive_mode_i(drive_mode),
      .cs_no(cs_no),
      .sclk_o(sclk_o),
      .sd_io(sd_io)
  );

endmodule
