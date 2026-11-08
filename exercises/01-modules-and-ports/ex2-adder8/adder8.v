// adder8.v - 8-bit adder from two ripple_adder4 instances (exercise 01.2).
`timescale 1ns/1ps

module adder8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire       cin,
  output wire [7:0] sum,
  output wire       cout
);

  // TODO: one internal carry wire and two ripple_adder4 instances.
  //       Then delete the two lines below.
  assign sum  = 8'd0;
  assign cout = 1'b0;

endmodule
