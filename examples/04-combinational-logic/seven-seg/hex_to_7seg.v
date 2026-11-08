// hex_to_7seg.v - shows a 4-bit value (0 to F) on a seven-segment display.
//
// Segment names and bit order (1 = segment on):
//
//      aaa          seg[0] = a
//     f   b         seg[1] = b
//     f   b         seg[2] = c
//      ggg          seg[3] = d
//     e   c         seg[4] = e
//     e   c         seg[5] = f
//      ddd          seg[6] = g
//
// Many boards have active-low segments (0 = on). Then use ~seg.
`timescale 1ns/1ps

module hex_to_7seg (
  input  wire [3:0] value,
  output reg  [6:0] seg     // {g, f, e, d, c, b, a}
);

  // A case statement with all 16 values is a lookup table (a ROM).
  // Every possible input has a line, so no latch can appear.
  always @(*) begin
    case (value)
      4'h0: seg = 7'b011_1111;
      4'h1: seg = 7'b000_0110;
      4'h2: seg = 7'b101_1011;
      4'h3: seg = 7'b100_1111;
      4'h4: seg = 7'b110_0110;
      4'h5: seg = 7'b110_1101;
      4'h6: seg = 7'b111_1101;
      4'h7: seg = 7'b000_0111;
      4'h8: seg = 7'b111_1111;
      4'h9: seg = 7'b110_1111;
      4'hA: seg = 7'b111_0111;
      4'hB: seg = 7'b111_1100;   // lower-case b
      4'hC: seg = 7'b011_1001;
      4'hD: seg = 7'b101_1110;   // lower-case d
      4'hE: seg = 7'b111_1001;
      4'hF: seg = 7'b111_0001;
      // A default is still good style: it covers x and z in simulation
      // and makes the intent clear to readers and tools.
      default: seg = 7'b000_0000;
    endcase
  end

endmodule
