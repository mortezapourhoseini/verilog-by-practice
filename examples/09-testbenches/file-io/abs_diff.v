// abs_diff.v - absolute difference |a - b| of two unsigned bytes.
// A small DUT for the file I/O testbench example.
`timescale 1ns/1ps

module abs_diff (
  input  wire [7:0] a,
  input  wire [7:0] b,
  output wire [7:0] y
);

  assign y = (a >= b) ? (a - b) : (b - a);

endmodule
