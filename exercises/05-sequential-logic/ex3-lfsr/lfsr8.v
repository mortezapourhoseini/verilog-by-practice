// lfsr8.v - 8-bit maximal-length LFSR (exercise 05.3).
`timescale 1ns/1ps

module lfsr8 (
  input  wire       clk,
  input  wire       rst,
  input  wire       en,
  output reg  [7:0] q
);

  always @(posedge clk) begin
    // TODO: load the seed on reset, shift with feedback when en = 1.
    if (rst)
      q <= 8'h01;
  end

endmodule
