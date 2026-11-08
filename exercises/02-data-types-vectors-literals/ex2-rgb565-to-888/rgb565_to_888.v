// rgb565_to_888.v - unpack a 16-bit pixel to three 8-bit colors (exercise 02.2).
`timescale 1ns/1ps

module rgb565_to_888 (
  input  wire [15:0] pix,
  output wire [7:0]  r8,
  output wire [7:0]  g8,
  output wire [7:0]  b8
);

  // TODO: replace these three lines.
  assign r8 = 8'd0;
  assign g8 = 8'd0;
  assign b8 = 8'd0;

endmodule
