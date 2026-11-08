// lut4.v - 4-input LUT model (given, do not change).
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
