// clz8.v - count leading zeros of a byte (exercise 04.2).
`timescale 1ns/1ps

module clz8 (
  input  wire [7:0] d,
  output reg  [3:0] count
);

  always @(*) begin
    // TODO: replace this line.
    count = 4'd8;
  end

endmodule
