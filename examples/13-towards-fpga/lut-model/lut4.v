// lut4.v - a model of a 4-input look-up table (LUT), the basic logic
// element of most FPGAs.
//
// A LUT is a tiny ROM: 16 bits of memory (INIT) and a 16-to-1 multiplexer.
// The four inputs form the address. ANY function of 4 inputs fits in one LUT:
// you only change INIT. Bit n of INIT is the output for inputs {i3,i2,i1,i0} = n.
//
// Real FPGA primitives look similar (for example LUT4 or LUT6 with an
// INIT parameter). Modern FPGAs mostly have 6-input LUTs (64 INIT bits).
`timescale 1ns/1ps

module lut4 #(
  parameter [15:0] INIT = 16'h0000
) (
  input  wire i0,
  input  wire i1,
  input  wire i2,
  input  wire i3,
  output wire o
);

  assign o = INIT[{i3, i2, i1, i0}];

endmodule
