// mux2_4bit.v - 4-bit 2-to-1 multiplexer (exercise 00.1).
`timescale 1ns/1ps

module mux2_4bit (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       sel,
  output wire [3:0] y
);

  // TODO: replace this line. y must be a when sel = 0, and b when sel = 1.
  assign y = 4'b0000;

endmodule
