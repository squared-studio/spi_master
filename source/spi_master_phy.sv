// SPI Master PHY Module (spi_master_phy.sv)
// -----------------------------------------------
// This module implements the physical layer interface for the SPI Master, managing the
// bidirectional SPI signals based on the configured SPI mode and drive mode.
// -----------------------------------------------
// Copyright (c) 2025 Squared Studio
// Author: Foez Ahmed (foez.official@gmail.com)

`include "common_defines.svh"

module spi_master_phy
  import spi_master_pkg::*;
(
    // Input clock from pad or external clock source. Some SPI modes may
    // require inverting or otherwise transforming this clock for pad drive.
    input logic clk_i,

    // SPI bus data vectors (types defined in `spi_master_pkg`):
    // - `spi_sdo_i`: data driven by PHY to pads (MOSI/outputs)
    // - `spi_sdi_o`: data sampled from pads (MISO/inputs)
    input  spi_bus_t spi_sdo_i,
    output spi_bus_t spi_sdi_o,

    // SPI mode bits (e.g. CPOL/CPHA equivalent) used to configure clock
    // polarity and pad pull states.
    input spi_mode_t         spi_mode_i,
    // Drive mode selects IDLE / STD / DUAL / QUAD and input/output behavior.
    input spi_master_drive_t drive_mode_i,

    // Physical pad connections. These are inout because pad primitives handle
    // tri-state and weak pull behaviour.
    inout wire            cs_no,
    inout wire            sclk_o,
    inout `SPI_BUS_WIRE_T sd_io
);

  // High when PHY should actively drive the pads (not IDLE)
  logic is_active;

  // Per-wire drive enable (1 => drive that SDIO line). Width equals `NUM_WIRES`.
  spi_bus_t spi_sdo_en;

  // Internal clock value to drive SCLK pad (may be inverted based on mode).
  logic clk;

  // Registered enable used when driving the SCLK pad to avoid glitches.
  logic clk_en;

  // Compute whether the PHY should actively drive outputs (combinational).
  always_comb is_active = (drive_mode_i != IDLE);

  // Translate abstract drive_mode into per-wire write-enable signals. Input
  // modes clear the enables so the pad primitives present inputs to the PHY.
  always_comb begin
    case (drive_mode_i)
      default:  spi_sdo_en = NO_DRIVE;  // IDLE, DUMMY
      STD_OUT:  spi_sdo_en = SINGLE_DRIVE;  // single-wire output
      STD_IN:   spi_sdo_en = NO_DRIVE;  // single-wire input
      DUAL_OUT: spi_sdo_en = DUAL_DRIVE;  // two-wire output
      DUAL_IN:  spi_sdo_en = NO_DRIVE;  // two-wire input
      QUAD_OUT: spi_sdo_en = QUAD_DRIVE;  // four-wire output
      QUAD_IN:  spi_sdo_en = NO_DRIVE;  // four-wire input
    endcase
  end

  // Adjust clock polarity based on mode bit0 (CPOL/CPHA handling).
  always_comb clk = (spi_mode_i[0]) ? ~clk_i : clk_i;

  // Chip-select pad: drive active-low CS when PHY is active. Pad primitive
  // handles the physical pull-up/pull-down and tri-state behavior.
  spi_master_pad pad_csn (
      .write_data_i('0),
      .write_enable_i(is_active),
      .pull_up_i(1'b1),
      .pull_down_i(1'b0),
      .read_data_o(),
      .pad_io(cs_no)
  );

  // Register the clock enable to align pad driving with the clock domain and
  // to reduce the risk of glitches when enabling/disabling SCLK.
  always_ff @(posedge clk_i) begin
    clk_en <= is_active;
  end

  // SCLK pad: drive the computed `clk` when `clk_en` is asserted. Pull config
  // uses mode bit1 to set idle biasing consistent with selected SPI mode.
  spi_master_pad pad_sclk (
      .write_data_i(clk),
      .write_enable_i(clk_en),
      .pull_up_i(spi_mode_i[1]),
      .pull_down_i(~spi_mode_i[1]),
      .read_data_o(),
      .pad_io(sclk_o)
  );

  // Instantiate a pad for each SDIO wire. Each pad is configured with the
  // corresponding data bit, enable and pull direction; sampled data is placed
  // on `spi_sdi_o` back into the PHY.
  for (genvar i = 0; i < NUM_WIRES; i++) begin : g_sdio_pads
    spi_master_pad pad_sdio (
        .write_data_i(spi_sdo_i[i]),
        .write_enable_i(spi_sdo_en[i]),
        .pull_up_i(spi_mode_i[1]),
        .pull_down_i(~spi_mode_i[1]),
        .read_data_o(spi_sdi_o[i]),
        .pad_io(sd_io[i])
    );
  end

endmodule
