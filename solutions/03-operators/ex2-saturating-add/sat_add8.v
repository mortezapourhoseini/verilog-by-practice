// sat_add8.v - unsigned and signed saturating adders (solution 03.2).
`timescale 1ns/1ps

module sat_add8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  output wire [7:0] usum,
  output wire [7:0] ssum
);

  // Unsigned: a 9-bit sum keeps the carry.
  wire [8:0] full = a + b;
  assign usum = full[8] ? 8'hFF : full[7:0];

  // Signed: the low 8 bits are the same for signed and unsigned addition.
  wire [7:0] raw = full[7:0];

  // Overflow: same input signs, but a different result sign.
  wire ovf = (a[7] == b[7]) && (raw[7] != a[7]);

  // On overflow, clamp to the most negative (-128) or most positive (127) value.
  assign ssum = ovf ? (a[7] ? 8'h80 : 8'h7F) : raw;

endmodule
