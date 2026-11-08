// sort3.v - sorts three unsigned bytes (combinational).
// lo <= mid <= hi, and {lo, mid, hi} is a permutation of {a, b, c}.
//
// Three compare-and-swap steps, like a tiny sorting network:
//   step 1: sort (a, b)
//   step 2: sort (the larger one, c)
//   step 3: sort (the two smaller ones)
`timescale 1ns/1ps

module sort3 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire [7:0] c,
  output reg  [7:0] lo,
  output reg  [7:0] mid,
  output reg  [7:0] hi
);

  reg [7:0] x1, y1;   // after step 1: x1 <= y1
  reg [7:0] x2, y2;   // after step 2: y2 is the maximum

  always @(*) begin
    // step 1
    if (a <= b) begin x1 = a; y1 = b; end
    else        begin x1 = b; y1 = a; end
    // step 2
    if (y1 <= c) begin x2 = y1; y2 = c;  end
    else         begin x2 = c;  y2 = y1; end
    // step 3
    if (x1 <= x2) begin lo = x1; mid = x2; end
    else          begin lo = x2; mid = x1; end
    hi = y2;
  end

endmodule
