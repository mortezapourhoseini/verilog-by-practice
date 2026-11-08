// mux2.v - 2-to-1 multiplexer.
//
// When sel is 0, the output y follows input a.
// When sel is 1, the output y follows input b.
`timescale 1ns/1ps

module mux2 (
  input  wire a,
  input  wire b,
  input  wire sel,
  output wire y
);

  // The conditional operator "? :" describes a multiplexer directly.
  assign y = sel ? b : a;

endmodule
