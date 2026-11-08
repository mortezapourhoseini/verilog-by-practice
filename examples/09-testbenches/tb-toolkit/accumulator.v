// accumulator.v - adds every valid input to a running sum.
// A small DUT for the testbench toolkit example.
`timescale 1ns/1ps

module accumulator (
  input  wire        clk,
  input  wire        rst,
  input  wire        clear,   // set the sum to 0 (synchronous)
  input  wire        valid,   // din is valid in this cycle
  input  wire [7:0]  din,
  output reg  [15:0] sum
);

  always @(posedge clk) begin
    if (rst || clear)
      sum <= 16'd0;
    else if (valid)
      sum <= sum + din;     // din is zero-extended to 16 bits
  end

endmodule
