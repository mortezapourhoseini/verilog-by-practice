// half_adder.v - adds two bits (solution 00.2).
`timescale 1ns/1ps

module half_adder (
  input  wire a,
  input  wire b,
  output wire sum,
  output wire carry
);

  assign sum   = a ^ b;   // 1 when exactly one input is 1
  assign carry = a & b;   // 1 only when both inputs are 1

endmodule
