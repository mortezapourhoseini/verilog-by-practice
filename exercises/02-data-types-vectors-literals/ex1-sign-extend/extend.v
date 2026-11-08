// extend.v - zero and sign extension from 8 to 16 bits (exercise 02.1).
`timescale 1ns/1ps

module extend (
  input  wire [7:0]  in,
  output wire [15:0] zext,
  output wire [15:0] sext
);

  // TODO: replace these two lines.
  assign zext = 16'd0;
  assign sext = 16'd0;

endmodule
