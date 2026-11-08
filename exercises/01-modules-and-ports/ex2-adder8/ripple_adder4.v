// ripple_adder4.v - 4-bit ripple-carry adder made of 4 full adders.
//
// The carry "ripples" from bit 0 to bit 3:
//   cin -> fa0 -> c[1] -> fa1 -> c[2] -> fa2 -> c[3] -> fa3 -> cout

// With "none", a misspelled signal name is an error instead of a new
// 1-bit wire. We switch it back to "wire" at the end of the file, so
// other files are not affected.
`default_nettype none
`timescale 1ns/1ps

module ripple_adder4 (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       cin,
  output wire [3:0] sum,
  output wire       cout
);

  // c[i] is the carry INTO bit i. c[0] is cin.
  wire [4:0] c;

  assign c[0] = cin;

  full_adder fa0 (.a(a[0]), .b(b[0]), .cin(c[0]), .sum(sum[0]), .cout(c[1]));
  full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c[1]), .sum(sum[1]), .cout(c[2]));
  full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c[2]), .sum(sum[2]), .cout(c[3]));
  full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c[3]), .sum(sum[3]), .cout(c[4]));

  assign cout = c[4];

endmodule

`default_nettype wire
