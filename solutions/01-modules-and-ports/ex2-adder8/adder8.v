// adder8.v - 8-bit adder from two ripple_adder4 instances (solution 01.2).
`timescale 1ns/1ps

module adder8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire       cin,
  output wire [7:0] sum,
  output wire       cout
);

  wire c4;   // carry from bit 3 into bit 4

  ripple_adder4 lo (
    .a    (a[3:0]),
    .b    (b[3:0]),
    .cin  (cin),
    .sum  (sum[3:0]),
    .cout (c4)
  );

  ripple_adder4 hi (
    .a    (a[7:4]),
    .b    (b[7:4]),
    .cin  (c4),
    .sum  (sum[7:4]),
    .cout (cout)
  );

endmodule
