// rotl.v - barrel rotator, rotate left (solution 07.2).
`timescale 1ns/1ps

module rotl #(
  parameter WIDTH   = 8,
  parameter SHIFT_W = 3
) (
  input  wire [WIDTH-1:0]   din,
  input  wire [SHIFT_W-1:0] amt,
  output wire [WIDTH-1:0]   dout
);

  // stage[0] is the input. stage[k+1] is the output of stage k.
  wire [WIDTH-1:0] stage [0:SHIFT_W];
  assign stage[0] = din;

  genvar k;
  generate
    for (k = 0; k < SHIFT_W; k = k + 1) begin : rot_stage
      // Stage k rotates by 2^k = (1 << k). Because k is a genvar, this
      // is a constant, so the part-select bounds are constant too.
      assign stage[k+1] = amt[k]
                        ? {stage[k][WIDTH-1-(1<<k):0], stage[k][WIDTH-1:WIDTH-(1<<k)]}
                        : stage[k];
    end
  endgenerate

  assign dout = stage[SHIFT_W];

endmodule
