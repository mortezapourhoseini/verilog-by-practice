// ripple_adder.v - ripple-carry adder of any width.
//
// Chapter 01 wrote four full_adder instances by hand. Here a generate
// loop writes WIDTH instances, and WIDTH is a parameter: every instance
// of ripple_adder can have its own width.
`default_nettype none
`timescale 1ns/1ps

module ripple_adder #(
  parameter WIDTH = 8                    // default value
) (
  input  wire [WIDTH-1:0] a,
  input  wire [WIDTH-1:0] b,
  input  wire             cin,
  output wire [WIDTH-1:0] sum,
  output wire             cout
);

  wire [WIDTH:0] c;                      // c[i] = carry into bit i
  assign c[0] = cin;

  // genvar: a loop variable that exists only at elaboration time.
  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : bit_slice   // the block needs a name
      full_adder fa (
        .a    (a[i]),
        .b    (b[i]),
        .cin  (c[i]),
        .sum  (sum[i]),
        .cout (c[i+1])
      );
    end
  endgenerate

  assign cout = c[WIDTH];

endmodule

`default_nettype wire
