// swap.v - two registers that should swap their values at every edge.
//
// swap_nonblocking: correct. Both blocks read the OLD values, then both
//                   registers are updated. a and b exchange values.
// swap_blocking:    a RACE. The two blocks run in some order chosen by the
//                   simulator. Whichever runs first changes its register
//                   at once, and the second block reads the NEW value.
//                   Result: a == b after the first edge, and which value
//                   survives depends on the simulator.
`timescale 1ns/1ps

module swap_nonblocking (
  input  wire       clk,
  input  wire       load,
  input  wire [7:0] init_a,
  input  wire [7:0] init_b,
  output reg  [7:0] a,
  output reg  [7:0] b
);
  always @(posedge clk)
    if (load) a <= init_a;
    else      a <= b;

  always @(posedge clk)
    if (load) b <= init_b;
    else      b <= a;
endmodule

module swap_blocking (
  input  wire       clk,
  input  wire       load,
  input  wire [7:0] init_a,
  input  wire [7:0] init_b,
  output reg  [7:0] a,
  output reg  [7:0] b
);
  always @(posedge clk)
    if (load) a = init_a;
    else      a = b;        // may read the new b ...

  always @(posedge clk)
    if (load) b = init_b;
    else      b = a;        // ... or the new a
endmodule
