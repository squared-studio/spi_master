// SPI Master Clock Divider Module
// This module divides the input clock by a programmable divisor to generate the SPI clock output.
// The divisor is specified by the div_i input, and the width of the divisor is parameterized by DIV_WIDTH.

module spi_master_clk_div
import spi_master_pkg::*;
(
    input logic     arst_ni,  // Asynchronous reset, active low
    input logic     clk_i,    // Input clock
    input clk_div_t div_i,    // Clock divisor value

    output logic clk_o  // Divided clock output
);

  clk_div_t counter_q;  // Current counter value (registered)
  clk_div_t counter_n;  // Next counter value (combinational)
  logic     toggle_en;  // Enable signal for toggling the output clock

  always_comb toggle_en = (counter_q == '0);

  // Combinational logic to calculate the next counter value
  // If divisor is 0, counter stays at 0 (no division)
  // Otherwise, increment counter, and reset when it reaches the divisor
  always_comb begin
    if (div_i == '0) begin
      counter_n = '0;
    end else begin
      counter_n = counter_q + 1;
      if (counter_n >= div_i) begin
        counter_n = '0;
      end
    end
  end

  // Register the counter value on clock edge or reset
  always @(clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      counter_q <= '0;
    end else begin
      counter_q <= counter_n;
    end
  end

  // Toggle the output clock when toggle_en is high
  always @(clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      clk_o <= '0;
    end else begin
      if (toggle_en) begin
        clk_o <= ~clk_o;
      end
    end
  end

endmodule
