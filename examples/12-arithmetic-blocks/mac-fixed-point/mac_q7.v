// mac_q7.v - pipelined multiply-accumulate unit for Q1.7 fixed-point numbers.
//
// Number format Q1.7: 8-bit two's complement, 7 bits after the binary point.
//   value = integer / 128,  range -1.0 .. +0.9921875,  step 1/128
//
// Data path:
//   stage 1 (register): prod = a * b             Q2.14, 16 bits
//   stage 2 (register): acc  = acc + prod        Q6.14, 20 bits (guard bits)
//   output  (comb.):    y    = round(acc) to Q1.7, with saturation
//
// "first" marks the first sample of a new sum: acc starts from prod
// instead of acc + prod. It travels through the pipeline with "valid".
`timescale 1ns/1ps

module mac_q7 (
  input  wire              clk,
  input  wire              rst,
  input  wire              valid,     // a and b are valid
  input  wire              first,     // start a new sum with this sample
  input  wire signed [7:0] a,         // Q1.7
  input  wire signed [7:0] b,         // Q1.7
  output reg  signed [19:0] acc,      // Q6.14, full precision
  output reg               acc_valid, // acc changed in the last cycle
  output wire signed [7:0] y          // acc rounded and saturated to Q1.7
);

  // ---------------- stage 1: multiply ----------------
  reg signed [15:0] prod;   // Q1.7 x Q1.7 = Q2.14
  reg               v1;
  reg               f1;

  always @(posedge clk) begin
    if (rst) begin
      v1 <= 1'b0;
      f1 <= 1'b0;
      prod <= 16'sd0;
    end else begin
      v1   <= valid;
      f1   <= first;
      prod <= a * b;        // both operands signed: a signed product
    end
  end

  // ---------------- stage 2: accumulate ----------------
  // 20 bits = 16 bits of product + 4 guard bits: room for 16 products of
  // the largest size (+1.0) without overflow.
  always @(posedge clk) begin
    if (rst) begin
      acc       <= 20'sd0;
      acc_valid <= 1'b0;
    end else begin
      acc_valid <= v1;
      if (v1) begin
        if (f1) acc <= prod;          // sign-extended to 20 bits
        else    acc <= acc + prod;
      end
    end
  end

  // ---------------- output: round and saturate ----------------
  // Q6.14 -> Q1.7: drop 7 fraction bits. Add half an LSB (64) first, so the
  // result is rounded to nearest instead of truncated toward minus infinity.
  wire signed [20:0] rounded = acc + 21'sd64;
  wire signed [13:0] shifted = rounded >>> 7;   // Q7.7 (arithmetic shift)

  // Saturate to the Q1.7 range [-128, 127] (integer view).
  assign y = (shifted >  14'sd127)  ? 8'sd127  :
             (shifted < -14'sd128)  ? -8'sd128 :
             shifted[7:0];

endmodule
