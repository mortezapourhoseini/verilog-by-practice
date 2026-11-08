// lfsr8.v - 8-bit maximal-length LFSR (solution 05.3).
//
// Taps 8, 6, 5, 4 (bits 7, 5, 4, 3) give the longest possible sequence:
// all 255 non-zero values. The value 0 is a trap: 0 XOR 0 = 0, so the
// register would stay 0 forever. That is why the seed must not be 0.
`timescale 1ns/1ps

module lfsr8 (
  input  wire       clk,
  input  wire       rst,
  input  wire       en,
  output reg  [7:0] q
);

  wire feedback = q[7] ^ q[5] ^ q[4] ^ q[3];

  always @(posedge clk) begin
    if (rst)
      q <= 8'h01;
    else if (en)
      q <= {q[6:0], feedback};
  end

endmodule
