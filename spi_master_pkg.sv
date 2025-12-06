// SPI Master Package (spi_master_pkg.sv)
// -----------------------------------------------
// This package defines types and enumerations used by the SPI Master module.
// -----------------------------------------------
// Copyright (c) 2025 Squared Studio
// Author: Foez Ahmed (foez.official@gmail.com)

package spi_master_pkg;

  // SPI Mode Definitions
  typedef enum logic [1:0] {
    SPI_MODE_0 = 2'b00,  // CPOL = 0, CPHA = 0
    SPI_MODE_1 = 2'b01,  // CPOL = 0, CPHA = 1
    SPI_MODE_2 = 2'b10,  // CPOL = 1, CPHA = 0
    SPI_MODE_3 = 2'b11   // CPOL = 1, CPHA = 1
  } spi_mode_t;

  typedef enum logic [2:0] {
    IDLE,      // SPI Idle State. All wires are high impedance
    DUMMY,     // Dummy Cycle State. All wires are high impedance
    STD_OUT,   // Standard Output Mode (1 wire output)
    STD_IN,    // Standard Input Mode (1 wire input)
    DUAL_OUT,  // Dual Output Mode (2 wire output)
    DUAL_IN,   // Dual Input Mode (2 wire input)
    QUAD_OUT,  // Quad Output Mode (4 wire output)
    QUAD_IN    // Quad Input Mode (4 wire input)
  } spi_master_drive_e;

endpackage
