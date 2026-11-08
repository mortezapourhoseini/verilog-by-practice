// mux_styles.v - three ways to write the same 8-bit 2-to-1 mux.
// In hardware they are identical. In simulation they treat an UNKNOWN
// select (x) differently. See tb_mux_styles.v and chapter 10.
`timescale 1ns/1ps

// 1. if / else: an x condition is treated as FALSE -> takes the else
//    branch. The x disappears ("x-optimism"): the bug is hidden.
module mux_if (
  input  wire       sel,
  input  wire [7:0] a,
  input  wire [7:0] b,
  output reg  [7:0] y
);
  always @(*) begin
    if (sel) y = a;
    else     y = b;
  end
endmodule

// 2. ? : with an x condition merges both inputs bit by bit:
//    equal bits stay, different bits become x.
module mux_ternary (
  input  wire       sel,
  input  wire [7:0] a,
  input  wire [7:0] b,
  output wire [7:0] y
);
  assign y = sel ? a : b;
endmodule

// 3. case with an x default: an x select matches no item, so the
//    default runs and makes the whole output x. The bug stays visible.
//    Synthesis treats the x as "don't care", which costs nothing.
module mux_case (
  input  wire       sel,
  input  wire [7:0] a,
  input  wire [7:0] b,
  output reg  [7:0] y
);
  always @(*) begin
    case (sel)
      1'b1:    y = a;
      1'b0:    y = b;
      default: y = 8'bx;
    endcase
  end
endmodule
