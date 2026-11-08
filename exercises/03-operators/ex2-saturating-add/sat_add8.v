// sat_add8.v - unsigned and signed saturating adders (exercise 03.2).
`timescale 1ns/1ps

module sat_add8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  output wire [7:0] usum,
  output wire [7:0] ssum
);

  // TODO: replace these two lines.
  assign usum = a + b;   // wraps around: wrong when the sum is too big
  assign ssum = a + b;   // wraps around: wrong on signed overflow

endmodule
