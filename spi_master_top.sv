// SPI Master Top-Level Module (spi_master_top.sv)
// -----------------------------------------------
// This module serves as the top-level wrapper for the SPI Master core, integrating AXI4-Lite slave
// interface for configuration and control, and managing the SPI communication through a quad-SPI
// interface.
// -----------------------------------------------
// Copyright (c) 2025 Squared Studio
// Author: Foez Ahmed (foez.official@gmail.com)

module spi_master_top #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
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

    input wire       cs_no,
    input wire       sclk_o,
    inout wire [3:0] sd_io

);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Type Definitions
  //////////////////////////////////////////////////////////////////////////////////////////////////

  typedef enum logic [2:0] {
    IDLE,
    DUMMY,
    STD_OUT,
    STD_IN,
    DUAL_OUT,
    DUAL_IN,
    QUAD_OUT,
    QUAD_IN
  } drive_e;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Internal Signals
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [1:0] spi_mode;
  logic [3:0] spi_sdi;
  logic [3:0] spi_sdo;
  logic [3:0] spi_sdo_en;

  drive_e drive_mode;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Combinational Logic
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < 4; i++) begin
    assign sd_io[i]   = spi_sdo_en[i] ? spi_sdo[i] : 1'bz;
    assign spi_sdi[i] = sd_io[i];
  end

  always_comb begin
    drive_mode = IDLE;
    case (drive_mode)
      IDLE:     spi_sdo_en = 4'b0000;
      STD_OUT:  spi_sdo_en = 4'b0001;
      STD_IN:   spi_sdo_en = 4'b0000;
      DUAL_OUT: spi_sdo_en = 4'b0011;
      DUAL_IN:  spi_sdo_en = 4'b0000;
      QUAD_OUT: spi_sdo_en = 4'b1111;
      QUAD_IN:  spi_sdo_en = 4'b0000;
    endcase
  end

endmodule
