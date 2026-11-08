// decoder3to8.v - one-hot decoder with enable (exercise 04.1).
`timescale 1ns/1ps

module decoder3to8 (
  input  wire       en,
  input  wire [2:0] sel,
  output reg  [7:0] y
);

  always @(*) begin
    // TODO: replace this line with a default value and a case statement.
    y = 8'd0;
  end

endmodule
