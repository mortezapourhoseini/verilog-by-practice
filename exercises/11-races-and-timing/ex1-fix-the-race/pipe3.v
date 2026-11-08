// pipe3.v - 3-stage delay line WITH A RACE (exercise 11.1).
`timescale 1ns/1ps

module pipe3 (
  input  wire       clk,
  input  wire [7:0] din,
  output wire [7:0] dout
);

  reg [7:0] q1;
  reg [7:0] q2;
  reg [7:0] q3;

  // Each block alone looks fine. Together they race.
  always @(posedge clk) q1 = din;
  always @(posedge clk) q2 = q1;
  always @(posedge clk) q3 = q2;

  assign dout = q3;

endmodule
