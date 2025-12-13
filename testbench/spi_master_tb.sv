`include "common_defines.svh"

module spi_master_tb;

  import spi_master_pkg::*;

  logic arst_ni;
  logic clk_i;
  addr_t awaddr_i;
  prot_t awprot_i;
  logic awvalid_i;
  logic awready_o;
  data_t wdata_i;
  strb_t wstrb_i;
  logic wvalid_i;
  logic wready_o;
  resp_t bresp_o;
  logic bvalid_o;
  logic bready_i;
  addr_t araddr_i;
  prot_t arprot_i;
  logic arvalid_i;
  logic arready_o;
  data_t rdata_o;
  resp_t rresp_o;
  logic rvalid_o;
  logic rready_i;
  wire cs_no;
  wire sclk_o;
  `SPI_BUS_WIRE_T sd_io;

  task static apply_reset();
    #100ns;
    arst_ni <= '0;
    clk_i <= '0;
    awaddr_i <= '0;
    awprot_i <= '0;
    awvalid_i <= '0;
    wdata_i <= '0;
    wstrb_i <= '0;
    wvalid_i <= '0;
    bready_i <= '0;
    araddr_i <= '0;
    arprot_i <= '0;
    arvalid_i <= '0;
    rready_i <= '0;
    #100ns;
    arst_ni <= '1;
    #100ns;
  endtask

  task static toggle_clock(int cycles = -1);
    int cnt = 0;
    fork
      while (cnt != cycles) begin
        clk_i <= ~clk_i;
        #5ns;
        clk_i <= ~clk_i;
        #5ns;
        cnt++;
      end
    join_none
  endtask

  spi_master u_dut (
      .arst_ni  (arst_ni),
      .clk_i    (clk_i),
      .awaddr_i (awaddr_i),
      .awprot_i (awprot_i),
      .awvalid_i(awvalid_i),
      .awready_o(awready_o),
      .wdata_i  (wdata_i),
      .wstrb_i  (wstrb_i),
      .wvalid_i (wvalid_i),
      .wready_o (wready_o),
      .bresp_o  (bresp_o),
      .bvalid_o (bvalid_o),
      .bready_i (bready_i),
      .araddr_i (araddr_i),
      .arprot_i (arprot_i),
      .arvalid_i(arvalid_i),
      .arready_o(arready_o),
      .rdata_o  (rdata_o),
      .rresp_o  (rresp_o),
      .rvalid_o (rvalid_o),
      .rready_i (rready_i),
      .cs_no    (cs_no),
      .sclk_o   (sclk_o),
      .sd_io    (sd_io)
  );

  initial begin
    $dumpfile("spi_master_tb.vcd");
    $dumpvars(0, spi_master_tb);
    apply_reset();
    toggle_clock();
  end


endmodule
