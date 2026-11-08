// mux2_4bit.v - 4-bit 2-to-1 multiplexer (solution 00.1).
`timescale 1ns/1ps

module mux2_4bit (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       sel,
  output wire [3:0] y
);

  // "? :" selects the whole 4-bit bus at once.
  assign y = sel ? b : a;

endmodule
