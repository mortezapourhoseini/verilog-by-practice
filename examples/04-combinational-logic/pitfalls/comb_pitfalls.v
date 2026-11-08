// comb_pitfalls.v - two classic bugs in combinational always blocks,
// each next to its fix. The testbench shows how they behave.
//
// Warning: latch_bad really creates a latch when synthesized. Yosys
// reports "Latch inferred for signal ..." for it in the lint job.
`timescale 1ns/1ps

// ---------------------------------------------------------------------
// Bug 1: an accidental latch.
// When en is 0, q is not assigned. So q must KEEP its old value.
// Keeping a value needs memory: the tool builds a latch.
// ---------------------------------------------------------------------
module latch_bad (
  input  wire en,
  input  wire d,
  output reg  q
);
  always @(*) begin
    if (en)
      q = d;
    // no else: q keeps its value -> latch
  end
endmodule

// Fix: assign q in every path (here: an else branch).
module latch_fixed (
  input  wire en,
  input  wire d,
  output reg  q
);
  always @(*) begin
    if (en)
      q = d;
    else
      q = 1'b0;
  end
endmodule

// ---------------------------------------------------------------------
// Bug 2: an incomplete sensitivity list.
// The block runs only when a or b changes. A change of sel alone is
// ignored IN SIMULATION. Synthesis ignores the list and builds a normal
// mux, so simulation and hardware disagree.
// ---------------------------------------------------------------------
module mux_bad_sens (
  input  wire a,
  input  wire b,
  input  wire sel,
  output reg  y
);
  always @(a or b) begin   // sel is missing!
    y = sel ? b : a;
  end
endmodule

// Fix: always @(*) puts every signal that the block reads in the list.
module mux_good_sens (
  input  wire a,
  input  wire b,
  input  wire sel,
  output reg  y
);
  always @(*) begin
    y = sel ? b : a;
  end
endmodule
