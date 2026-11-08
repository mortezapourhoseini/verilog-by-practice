// pipe3.v - 3-stage delay line, race fixed (solution 11.1).
//
// Why the original failed: at a clock edge, all three blocks wake up.
// The simulator runs them one after the other (here in source order).
// q1 = din runs first, so q2 = q1 then reads the NEW q1, and q3 = q2
// the new q2: the whole pipeline collapses into one stage.
//
// Reversing the blocks "works" in Icarus, but only because of the order
// that this simulator happens to use. The standard does not define the
// order, so that is not a fix.
//
// With non-blocking assignments, every block reads the old values and
// the updates happen together, in any order.
`timescale 1ns/1ps

module pipe3 (
  input  wire       clk,
  input  wire [7:0] din,
  output wire [7:0] dout
);

  reg [7:0] q1;
  reg [7:0] q2;
  reg [7:0] q3;

  always @(posedge clk) q1 <= din;
  always @(posedge clk) q2 <= q1;
  always @(posedge clk) q3 <= q2;

  assign dout = q3;

endmodule
