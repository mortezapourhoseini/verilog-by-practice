// bitcount8.v - parity and number of ones in a byte (solution 03.1).
`timescale 1ns/1ps

module bitcount8 (
  input  wire [7:0] d,
  output wire       parity,
  output wire [3:0] ones
);

  // XOR of all bits is 1 when the number of ones is odd.
  assign parity = ^d;

  // The target is 4 bits wide, so every 1-bit operand is extended to
  // 4 bits BEFORE the additions. That is why the sum does not overflow.
  assign ones = d[0] + d[1] + d[2] + d[3] + d[4] + d[5] + d[6] + d[7];

endmodule
