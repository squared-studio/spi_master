// SPI Master Pad Module (spi_master_pad.sv)
// -----------------------------------------------
// This module implements a bidirectional pad interface for SPI signals, allowing for controlled
// data transmission and reception with optional pull-up and pull-down resistors.
// -----------------------------------------------
// Copyright (c) 2025 Squared Studio
// Author: Foez Ahmed (foez.official@gmail.com)

module spi_master_pad (
    input  wire write_data_i,    // Data to write to the pad when write_enable_i is high
    input  wire write_enable_i,  // Enable signal for writing data to the pad
    input  wire pull_up_i,       // Enable weak pull-up resistor on the pad
    input  wire pull_down_i,     // Enable weak pull-down resistor on the pad
    output wire read_data_o,     // Data read from the pad
    inout  wire pad_io           // Bidirectional pad pin
);

  // Drive the pad with write_data_i if write_enable_i is asserted, otherwise high-Z
  assign pad_io = write_enable_i ? write_data_i : 1'bz;

  // Apply weak pull-up if pull_up_i is asserted
  assign (weak1, weak0) pad_io = pull_up_i ? 1'b1 : 1'bz;

  // Apply weak pull-down if pull_down_i is asserted
  assign (weak1, weak0) pad_io = pull_down_i ? 1'b0 : 1'bz;

  // Read the current state of the pad
  assign read_data_o = pad_io;

endmodule
