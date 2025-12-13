// SPI Master Package (spi_master_pkg.sv)
// -----------------------------------------------
// This package defines types and enumerations used by the SPI Master module.
// -----------------------------------------------
// Copyright (c) 2025 Squared Studio
// Author: Foez Ahmed (foez.official@gmail.com)

package spi_master_pkg;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // System Bus Parameters
  //////////////////////////////////////////////////////////////////////////////////////////////////

  parameter int ADDR_WIDTH = 32;
  parameter int DATA_WIDTH = 32;

  typedef logic [ADDR_WIDTH-1:0] addr_t;
  typedef logic [2:0] prot_t;
  typedef logic [DATA_WIDTH-1:0] data_t;
  typedef logic [DATA_WIDTH/8-1:0] strb_t;
  typedef logic [1:0] resp_t;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Register offset
  //////////////////////////////////////////////////////////////////////////////////////////////////

  parameter addr_t REG_OFF_SPI_CSR_BASE = 32'h0000_0000;
  parameter addr_t REG_OFF_SPI_CSR_HIGH = 32'h0000_0004;
  parameter addr_t REG_OFF_SPI_MEM_BASE = 32'h0000_0008;
  parameter addr_t REG_OFF_SPI_MEM_HIGH = 32'h0000_000C;
  parameter addr_t REG_OFF_SPI_CLK_DIV = 32'h0000_0010;
  parameter addr_t REG_OFF_SPI_MODE = 32'h0000_0014;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Type definition for clock divisor
  //////////////////////////////////////////////////////////////////////////////////////////////////

  parameter int DIV_WIDTH = 12;
  typedef logic [DIV_WIDTH-1:0] clk_div_t;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // number of physical data wires (e.g., 4 for quad)
  //////////////////////////////////////////////////////////////////////////////////////////////////

  parameter int NUM_WIRES = 4;
  typedef logic [NUM_WIRES-1:0] spi_bus_t;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Type definitions for SPI modes
  //////////////////////////////////////////////////////////////////////////////////////////////////

  typedef logic [1:0] spi_mode_t;
  parameter spi_mode_t SPI_MODE_0 = 2'b00;  // CPOL = 0, CPHA = 0
  parameter spi_mode_t SPI_MODE_1 = 2'b01;  // CPOL = 0, CPHA = 1
  parameter spi_mode_t SPI_MODE_2 = 2'b10;  // CPOL = 1, CPHA = 0
  parameter spi_mode_t SPI_MODE_3 = 2'b11;  // CPOL = 1, CPHA = 1

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Type definition for SPI master drive states
  //////////////////////////////////////////////////////////////////////////////////////////////////

  typedef logic [2:0] spi_master_drive_t;
  parameter spi_master_drive_t IDLE = 3'd0;  // SPI Idle State. All wires are high impedance
  parameter spi_master_drive_t DUMMY = 3'd1;  // Dummy Cycle State. All wires are high impedance
  parameter spi_master_drive_t STD_OUT = 3'd2;  // Standard Output Mode (1 wire output)
  parameter spi_master_drive_t STD_IN = 3'd3;  // Standard Input Mode (1 wire input)
  parameter spi_master_drive_t DUAL_OUT = 3'd4;  // Dual Output Mode (2 wire output)
  parameter spi_master_drive_t DUAL_IN = 3'd5;  // Dual Input Mode (2 wire input)
  parameter spi_master_drive_t QUAD_OUT = 3'd6;  // Quad Output Mode (4 wire output)
  parameter spi_master_drive_t QUAD_IN = 3'd7;  // Quad Input Mode (4 wire input)

  parameter spi_bus_t NO_DRIVE = 'b0000;  // No drive on any wire (high impedance)
  parameter spi_bus_t SINGLE_DRIVE = 'b0001;  // No drive on any wire (high impedance)
  parameter spi_bus_t DUAL_DRIVE = 'b0011;  // No drive on any wire (high impedance)
  parameter spi_bus_t QUAD_DRIVE = 'b1111;  // No drive on any wire (high impedance)

endpackage
