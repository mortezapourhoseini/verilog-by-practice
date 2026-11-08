// extend.v - zero and sign extension from 8 to 16 bits (solution 02.1).
`timescale 1ns/1ps

module extend (
  input  wire [7:0]  in,
  output wire [15:0] zext,
  output wire [15:0] sext
);

  // Zero extension: eight 0 bits on the left.
  assign zext = {8'd0, in};

  // Sign extension: eight copies of the sign bit on the left.
  // This keeps the value the same in two's complement.
  assign sext = {{8{in[7]}}, in};

endmodule
