// smul8.v - signed 8 x 8 -> 16 multiplier (exercise 12.1).
`timescale 1ns/1ps

module smul8 (
  input  wire [7:0]  a,    // two's complement
  input  wire [7:0]  b,    // two's complement
  output wire [15:0] p     // two's complement product
);

  // BUG: a and b are unsigned here, so this is an unsigned multiply.
  assign p = a * b;

endmodule
