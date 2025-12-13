// SPI Master Register Interface (spi_master_regif.sv)
// -----------------------------------------------
// This module implements the AXI4-Lite slave register interface for the SPI Master core.
// -----------------------------------------------
// Copyright (c) 2025 Squared Studio
// Author: Foez Ahmed (foez.official@gmail.com)

module spi_master_regif
  import spi_master_pkg::*;
#(
    parameter addr_t DEFAULT_CSR_BASE = 32'h0000_0000,
    parameter addr_t DEFAULT_CSR_HIGH = 32'h0000_1000,
    parameter addr_t DEFAULT_MEM_BASE = 32'h2000_0000,
    parameter addr_t DEFAULT_MEM_HIGH = 32'h201F_FFFF
) (

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

    output clk_div_t  spi_clk_div_o,
    output spi_mode_t spi_mode_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Internal Signals
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic      write_enable;
  logic      read_enable;

  logic      aw_is_csr;
  logic      aw_is_mem;
  logic      ar_is_csr;
  logic      ar_is_mem;

  addr_t     csr_aw_addr;
  addr_t     csr_ar_addr;
  addr_t     mem_aw_addr;
  addr_t     mem_ar_addr;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Registers
  //////////////////////////////////////////////////////////////////////////////////////////////////

  addr_t     csr_base_addr;
  addr_t     csr_high_addr;
  addr_t     mem_base_addr;
  addr_t     mem_high_addr;
  clk_div_t  spi_clk_div;
  spi_mode_t spi_mode;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Assign Outputs
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign write_enable = awvalid_i & wvalid_i & bready_i;
  assign awready_o = write_enable;
  assign wready_o = write_enable;
  assign bvalid_o = write_enable;

  assign read_enable = arvalid_i & rready_i;
  assign arready_o = read_enable;
  assign rvalid_o = read_enable;

  assign spi_mode_o = spi_mode;

  assign aw_is_csr = (awaddr_i >= csr_base_addr) & (awaddr_i <= csr_high_addr);
  assign ar_is_csr = (araddr_i >= csr_base_addr) & (araddr_i <= csr_high_addr);

  assign aw_is_mem = (awaddr_i >= mem_base_addr) & (awaddr_i <= mem_high_addr);
  assign ar_is_mem = (araddr_i >= mem_base_addr) & (araddr_i <= mem_high_addr);

  assign csr_aw_addr = (awaddr_i - csr_base_addr) & 'hFFFF_FFFC;
  assign csr_ar_addr = (araddr_i - csr_base_addr) & 'hFFFF_FFFC;

  assign mem_aw_addr = (awaddr_i - mem_base_addr) & 'hFFFF_FFFC;
  assign mem_ar_addr = (araddr_i - mem_base_addr) & 'hFFFF_FFFC;

  always_comb begin
    rdata_o = '0;
    rresp_o = 2'b10;

    if (read_enable) begin

      if (ar_is_csr) begin
        case (csr_ar_addr)

          REG_OFF_SPI_CSR_BASE: begin
            rresp_o = 2'b00;
            rdata_o = csr_base_addr;
          end

          REG_OFF_SPI_CSR_HIGH: begin
            rresp_o = 2'b00;
            rdata_o = csr_high_addr;
          end

          REG_OFF_SPI_MEM_BASE: begin
            rresp_o = 2'b00;
            rdata_o = mem_base_addr;
          end

          REG_OFF_SPI_MEM_HIGH: begin
            rresp_o = 2'b00;
            rdata_o = mem_high_addr;
          end

          REG_OFF_SPI_CLK_DIV: begin
            rresp_o = 2'b00;
            rdata_o = {'0, spi_clk_div};
          end

          REG_OFF_SPI_MODE: begin
            rresp_o = 2'b00;
            rdata_o = {'0, spi_mode};
          end

        endcase
      end else if (ar_is_mem) begin
        // TODO
        rresp_o = 2'b00;
        rdata_o = '0;
      end
    end
  end

  always_comb begin
    bresp_o = 2'b10;

    if (write_enable && wstrb_i == '1) begin
      if (aw_is_csr) begin
        case (csr_aw_addr)

          REG_OFF_SPI_CSR_BASE, REG_OFF_SPI_CSR_HIGH, REG_OFF_SPI_MEM_BASE, REG_OFF_SPI_MEM_HIGH,
        REG_OFF_SPI_CLK_DIV, REG_OFF_SPI_MODE: begin
            bresp_o = 2'b00;
          end

        endcase
      end else if (aw_is_mem) begin
        // TODO
        bresp_o = 2'b00;
      end
    end
  end

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      csr_base_addr <= DEFAULT_CSR_BASE;
      csr_high_addr <= DEFAULT_CSR_HIGH;
      mem_base_addr <= DEFAULT_MEM_BASE;
      mem_high_addr <= DEFAULT_MEM_HIGH;
      spi_clk_div   <= 'h64;
      spi_mode      <= 'h3;
    end else begin
      if (bresp_o == 2'b00) begin
        if (aw_is_csr) begin
          case (csr_aw_addr)

            REG_OFF_SPI_CSR_BASE: begin
              csr_base_addr <= wdata_i;
            end

            REG_OFF_SPI_CSR_HIGH: begin
              csr_high_addr <= wdata_i;
            end

            REG_OFF_SPI_MEM_BASE: begin
              mem_base_addr <= wdata_i;
            end

            REG_OFF_SPI_MEM_HIGH: begin
              mem_high_addr <= wdata_i;
            end

            REG_OFF_SPI_CLK_DIV: begin
              spi_clk_div <= wdata_i[DIV_WIDTH-1:0];
            end

            REG_OFF_SPI_MODE: begin
              spi_mode <= wdata_i[1:0];
            end

          endcase
        end
      end
    end
  end


endmodule
