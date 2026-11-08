// rotl.v - barrel rotator, rotate left (exercise 07.2).
`timescale 1ns/1ps

module rotl #(
  parameter WIDTH   = 8,
  parameter SHIFT_W = 3
) (
  input  wire [WIDTH-1:0]   din,
  input  wire [SHIFT_W-1:0] amt,
  output wire [WIDTH-1:0]   dout
);

  // TODO: declare the stage array and write the generate loop.
  //       Then delete the line below.
  assign dout = din;

endmodule
