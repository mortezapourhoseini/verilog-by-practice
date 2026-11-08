// rgb565_to_888.v - unpack a 16-bit pixel to three 8-bit colors (solution 02.2).
`timescale 1ns/1ps

module rgb565_to_888 (
  input  wire [15:0] pix,
  output wire [7:0]  r8,
  output wire [7:0]  g8,
  output wire [7:0]  b8
);

  // Name the fields first. This makes the next lines easy to read.
  wire [4:0] r5 = pix[15:11];   // a wire with an initial assign (shortcut)
  wire [5:0] g6 = pix[10:5];
  wire [4:0] b5 = pix[4:0];

  // Put the value on top and repeat its highest bits below.
  assign r8 = {r5, r5[4:2]};
  assign g8 = {g6, g6[5:4]};
  assign b8 = {b5, b5[4:2]};

endmodule
