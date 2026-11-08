// muxn.v - parameterized N-to-1 multiplexer (solution 07.1).
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

  // Without the range check, sel >= N would read past the end of d,
  // and the result would be x in simulation (and anything in hardware).
  assign y = (sel < N) ? d[sel*WIDTH +: WIDTH] : {WIDTH{1'b0}};

endmodule
