// full_adder.v - adds three bits, built from two half adders.
//
//   a, b  --> [half_adder ha0] --s0--> [half_adder ha1] --> sum
//                   |c0                       |c1
//   cin -------------------------------------^
//                   c0 OR c1 --> cout
`timescale 1ns/1ps

module full_adder (
  input  wire a,
  input  wire b,
  input  wire cin,
  output wire sum,
  output wire cout
);

  // Internal wires connect the two instances.
  wire s0;
  wire c0;
  wire c1;

  // First half adder: a + b
  half_adder ha0 (
    .a     (a),
    .b     (b),
    .sum   (s0),
    .carry (c0)
  );

  // Second half adder: (a + b) + cin
  half_adder ha1 (
    .a     (s0),
    .b     (cin),
    .sum   (sum),
    .carry (c1)
  );

  // At most one of c0 and c1 can be 1, so OR is enough.
  assign cout = c0 | c1;

endmodule
