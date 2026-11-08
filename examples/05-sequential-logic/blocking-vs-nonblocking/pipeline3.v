// pipeline3.v - a 3-stage delay line written two ways.
//
// pipeline3_nb uses non-blocking "<=": three flip-flops, d is delayed by 3 cycles.
// pipeline3_b  uses blocking "=":     the three lines run in order, so q3
//              gets the NEW q2, which is the new q1, which is d. The
//              "pipeline" collapses into ONE flip-flop: a delay of 1 cycle.
`timescale 1ns/1ps

module pipeline3_nb (
  input  wire       clk,
  input  wire [7:0] d,
  output reg  [7:0] q1,
  output reg  [7:0] q2,
  output reg  [7:0] q3
);
  // All right-hand sides are read first (old values), then all
  // registers are updated together. Like real flip-flops.
  always @(posedge clk) begin
    q1 <= d;
    q2 <= q1;
    q3 <= q2;
  end
endmodule

module pipeline3_b (
  input  wire       clk,
  input  wire [7:0] d,
  output reg  [7:0] q1,
  output reg  [7:0] q2,
  output reg  [7:0] q3
);
  // WRONG for registers: each line sees the result of the line above.
  always @(posedge clk) begin
    q1 = d;
    q2 = q1;   // q1 already has the new value d
    q3 = q2;   // q2 already has the new value d
  end
endmodule
