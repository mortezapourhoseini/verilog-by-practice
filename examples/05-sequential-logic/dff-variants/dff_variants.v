// dff_variants.v - four common kinds of D flip-flop.
//
// All of them use the same pattern: always @(posedge clk ...) and the
// non-blocking assignment "<=". Only the reset and enable logic differ.
`timescale 1ns/1ps

// 1. Plain D flip-flop: q takes the value of d at every rising clock edge.
module dff (
  input  wire clk,
  input  wire d,
  output reg  q
);
  always @(posedge clk)
    q <= d;
endmodule

// 2. Synchronous reset: the reset is just another input, checked only at
//    the clock edge. rst is active high.
module dff_sync_reset (
  input  wire clk,
  input  wire rst,
  input  wire d,
  output reg  q
);
  always @(posedge clk) begin
    if (rst)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule

// 3. Asynchronous reset: q is cleared AT ONCE when rst_n falls, without
//    waiting for the clock. rst_n is active low (the "_n" suffix).
//    The reset edge must be in the sensitivity list.
module dff_async_reset (
  input  wire clk,
  input  wire rst_n,
  input  wire d,
  output reg  q
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule

// 4. Clock enable: q changes only at clock edges where en is 1.
//    Otherwise it keeps its value. This is NOT a latch: it is a
//    flip-flop with a multiplexer in front (q or d).
module dff_enable (
  input  wire clk,
  input  wire rst,
  input  wire en,
  input  wire d,
  output reg  q
);
  always @(posedge clk) begin
    if (rst)
      q <= 1'b0;
    else if (en)
      q <= d;
    // no else: keeping the value is what a flip-flop does anyway
  end
endmodule
