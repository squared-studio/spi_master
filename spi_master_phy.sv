// SPI Master PHY Module (spi_master_phy.sv)
// -----------------------------------------------
// This module implements the physical layer interface for the SPI Master, managing the
// bidirectional SPI signals based on the configured SPI mode and drive mode.
// -----------------------------------------------
// Copyright (c) 2025 Squared Studio
// Author: Foez Ahmed (foez.official@gmail.com)

module spi_master_phy
  import spi_master_pkg::*;
#(
    parameter int NUM_WIRES = 4
) (
    input  wire [NUM_WIRES-1:0] spi_sdo,
    input  wire [NUM_WIRES-1:0] spi_sdo_en,
    output wire [NUM_WIRES-1:0] spi_sdi,

    input spi_mode_t         spi_mode_i,
    input spi_master_drive_e drive_mode_i,

    inout wire                 cs_no,
    inout wire                 sclk_o,
    inout wire [NUM_WIRES-1:0] sd_io
);

  always_comb begin
    drive_mode = IDLE;
    case (drive_mode)
      IDLE:     spi_sdo_en = 4'b0000;
      DUMMY:    spi_sdo_en = 4'b0000;
      STD_OUT:  spi_sdo_en = 4'b0001;
      STD_IN:   spi_sdo_en = 4'b0000;
      DUAL_OUT: spi_sdo_en = 4'b0011;
      DUAL_IN:  spi_sdo_en = 4'b0000;
      QUAD_OUT: spi_sdo_en = 4'b1111;
      QUAD_IN:  spi_sdo_en = 4'b0000;
    endcase
  end

  // TODO
  spi_master_pad pad_csn (
      .write_data_i(spi_sdo[i]),
      .write_enable_i(spi_sdo_en[i]),
      .pull_up_i(1'b1),
      .pull_down_i(1'b0),
      .read_data_o(spi_sdi[i]),
      .pad_io(sd_io[i])
  );

  // TODO
  spi_master_pad pad_sclk (
      .write_data_i(),
      .write_enable_i(),
      .pull_up_i(),
      .pull_down_i(),
      .read_data_o(),
      .pad_io()
  );

  for (genvar i=0; i<NUM_WIRES; i++): begin : g_sdio_pads
    spi_master_pad pad_sdio (
      .write_data_i(spi_sdo[i]),
      .write_enable_i(spi_sdo_en[i]),
      .pull_up_i(1'b0),
      .pull_down_i(1'b0),
      .read_data_o(spi_sdi[i]),
      .pad_io(sd_io[i])
    );
  end

endmodule
