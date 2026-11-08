// gain_q15.v - Q1.15 multiply with rounding and saturation (exercise 12.2).
`timescale 1ns/1ps

module gain_q15 (
  input  wire [15:0] x,    // Q1.15 sample
  input  wire [15:0] g,    // Q1.15 gain
  output wire [15:0] y     // Q1.15 result
);

  // TODO: multiply, round, shift, saturate.
  // This stub truncates the unsigned product: wrong for negative values,
  // no rounding, no saturation.
  wire [31:0] prod = x * g;
  assign y = prod[30:15];

endmodule
