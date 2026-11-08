// gain_q15.v - Q1.15 multiply with rounding and saturation (solution 12.2).
`timescale 1ns/1ps

module gain_q15 (
  input  wire [15:0] x,    // Q1.15 sample
  input  wire [15:0] g,    // Q1.15 gain
  output wire [15:0] y     // Q1.15 result
);

  // 1. Signed product: Q1.15 x Q1.15 = Q2.30 in 32 bits.
  wire signed [31:0] prod = $signed(x) * $signed(g);

  // 2. Round: add half of the last bit we keep (bit 15 -> 2^14).
  //    33 bits, so the addition cannot overflow.
  wire signed [32:0] rounded = prod + 33'sd16384;

  // 3. Back to Q1.15: drop 15 fraction bits. 18 bits keep the range.
  wire signed [17:0] scaled = rounded >>> 15;

  // 4. Saturate. Only -1.0 * -1.0 = +1.0 (32768) is out of range.
  assign y = (scaled >  18'sd32767) ? 16'h7FFF :
             (scaled < -18'sd32768) ? 16'h8000 :
             scaled[15:0];

endmodule
