// field_extract.v - pick one byte from a 32-bit word, and swap byte order.
//
// Shows bit selects, part selects, indexed part selects (+:) and
// concatenation on vectors.
`timescale 1ns/1ps

module field_extract (
  input  wire [31:0] word,
  input  wire [1:0]  byte_sel,   // which byte: 0 = word[7:0], 3 = word[31:24]
  output wire [7:0]  byte_out,
  output wire [31:0] swapped,    // byte order reversed (endianness swap)
  output wire        msb,        // the most significant bit
  output wire [3:0]  top_nibble  // the 4 most significant bits
);

  // Indexed part select: start at bit (byte_sel * 8) and take 8 bits upward.
  // The start can be a signal, but the width (8) must be a constant.
  assign byte_out = word[byte_sel*8 +: 8];

  // Concatenation { } joins vectors. The first item becomes the MSBs.
  assign swapped = {word[7:0], word[15:8], word[23:16], word[31:24]};

  // A bit select and a constant part select.
  assign msb        = word[31];
  assign top_nibble = word[31:28];

endmodule
