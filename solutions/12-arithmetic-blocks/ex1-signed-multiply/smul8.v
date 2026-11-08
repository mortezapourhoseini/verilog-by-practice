// smul8.v - signed 8 x 8 -> 16 multiplier (solution 12.1).
//
// Why a * b was wrong: with unsigned operands, -3 (8'hFD) is read as 253.
// 253 * 5 = 1265 = 16'h04F1, not -15 = 16'hFFF1. (The low 8 bits agree,
// the high bits do not.)
`timescale 1ns/1ps

module smul8 (
  input  wire [7:0]  a,    // two's complement
  input  wire [7:0]  b,    // two's complement
  output wire [15:0] p     // two's complement product
);

  // Both operands are signed, and the 16-bit target is wide enough.
  // The operands are sign-extended to 16 bits before the multiply.
  assign p = $signed(a) * $signed(b);

  // Bonus version without $signed (same hardware):
  //   wire [15:0] a16 = {{8{a[7]}}, a};
  //   wire [15:0] b16 = {{8{b[7]}}, b};
  //   assign p = a16 * b16;   // the low 16 bits of the product are correct

endmodule
