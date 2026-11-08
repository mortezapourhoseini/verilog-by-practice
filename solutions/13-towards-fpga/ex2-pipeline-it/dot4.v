// dot4.v - 4-element dot product, 3 pipeline stages (solution 13.2).
//
//   stage 1: p0..p3 = a_k * b_k          (16 bits, one multiplier per register)
//   stage 2: s01 = p0 + p1, s23 = p2 + p3 (17 bits, one adder per register)
//   stage 3: y = s01 + s23               (18 bits)
// The longest path is now one multiplier, instead of a multiplier plus
// two adder levels.
`timescale 1ns/1ps

module dot4 (
  input  wire        clk,
  input  wire        rst,
  input  wire        valid_in,
  input  wire [31:0] a,
  input  wire [31:0] b,
  output reg  [17:0] y,
  output reg         valid_out
);

  reg [15:0] p0, p1, p2, p3;
  reg [16:0] s01, s23;
  reg        v1, v2;

  // Data pipeline: no reset needed, valid tells which values matter.
  always @(posedge clk) begin
    // stage 1
    p0 <= a[ 7: 0] * b[ 7: 0];
    p1 <= a[15: 8] * b[15: 8];
    p2 <= a[23:16] * b[23:16];
    p3 <= a[31:24] * b[31:24];
    // stage 2
    s01 <= p0 + p1;
    s23 <= p2 + p3;
    // stage 3
    y <= s01 + s23;
  end

  // Control pipeline: reset, so valid_out is 0 after reset.
  always @(posedge clk) begin
    if (rst) begin
      v1 <= 1'b0; v2 <= 1'b0; valid_out <= 1'b0;
    end else begin
      v1 <= valid_in; v2 <= v1; valid_out <= v2;
    end
  end

endmodule
