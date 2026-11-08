// full_adder_luts.v - a full adder built from two LUTs, the way synthesis
// maps it onto an FPGA.
//
// How to find INIT: write the truth table with the address n = {i3,i2,i1,i0},
// and put the output for address n into bit n.
//
//   n  i2(cin) i1(b) i0(a) | sum  cout
//   0     0      0     0   |  0    0
//   1     0      0     1   |  1    0
//   2     0      1     0   |  1    0
//   3     0      1     1   |  0    1
//   4     1      0     0   |  1    0
//   5     1      0     1   |  0    1
//   6     1      1     0   |  0    1
//   7     1      1     1   |  1    1
//
//   sum  bits 7..0 = 1001_0110 = 8'h96
//   cout bits 7..0 = 1110_1000 = 8'hE8
// i3 is not used, so addresses 8..15 repeat 0..7: INIT = 16'h9696, 16'hE8E8.
`timescale 1ns/1ps

module full_adder_luts (
  input  wire a,
  input  wire b,
  input  wire cin,
  output wire sum,
  output wire cout
);

  lut4 #(.INIT(16'h9696)) lut_sum  (.i0(a), .i1(b), .i2(cin), .i3(1'b0), .o(sum));
  lut4 #(.INIT(16'hE8E8)) lut_cout (.i0(a), .i1(b), .i2(cin), .i3(1'b0), .o(cout));

endmodule
