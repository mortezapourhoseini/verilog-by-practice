// cla4.v - 4-bit carry-lookahead adder.
//
// A ripple-carry adder waits for each carry in turn: the delay grows with
// the width. A carry-lookahead adder computes all carries in parallel from
// two signals per bit:
//   generate  g[i] = a[i] & b[i]   (this bit makes a carry by itself)
//   propagate p[i] = a[i] ^ b[i]   (this bit passes an incoming carry on)
// Then  c[i+1] = g[i] | (p[i] & c[i]), expanded so no carry waits for another.
`timescale 1ns/1ps

module cla4 (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       cin,
  output wire [3:0] sum,
  output wire       cout
);

  wire [3:0] g = a & b;
  wire [3:0] p = a ^ b;
  wire [4:0] c;

  assign c[0] = cin;
  assign c[1] = g[0] | (p[0] & c[0]);
  assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
  assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0])
                     | (p[2] & p[1] & p[0] & c[0]);
  assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1])
                     | (p[3] & p[2] & p[1] & g[0])
                     | (p[3] & p[2] & p[1] & p[0] & c[0]);

  assign sum  = p ^ c[3:0];
  assign cout = c[4];

endmodule
