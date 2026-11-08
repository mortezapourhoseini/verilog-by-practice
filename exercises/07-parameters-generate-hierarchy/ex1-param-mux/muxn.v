// muxn.v - parameterized N-to-1 multiplexer (exercise 07.1).
`timescale 1ns/1ps

module muxn #(
  parameter WIDTH = 8,
  parameter N     = 4,
  parameter SEL_W = 2
) (
  input  wire [N*WIDTH-1:0] d,
  input  wire [SEL_W-1:0]   sel,
  output wire [WIDTH-1:0]   y
);

  // TODO: select input number sel. Output 0 when sel >= N.
  assign y = {WIDTH{1'b0}};

endmodule
