// bitcount8.v - parity and number of ones in a byte (exercise 03.1).
`timescale 1ns/1ps

module bitcount8 (
  input  wire [7:0] d,
  output wire       parity,
  output wire [3:0] ones
);

  // TODO: replace these two lines.
  assign parity = 1'b0;
  assign ones   = 4'd0;

endmodule
