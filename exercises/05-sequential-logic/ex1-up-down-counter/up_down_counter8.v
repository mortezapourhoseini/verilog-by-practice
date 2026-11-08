// up_down_counter8.v - up/down counter with load (exercise 05.1).
`timescale 1ns/1ps

module up_down_counter8 (
  input  wire       clk,
  input  wire       rst,
  input  wire       load,
  input  wire [7:0] load_value,
  input  wire       en,
  input  wire       up,
  output reg  [7:0] count
);

  always @(posedge clk) begin
    // TODO: reset, load, then count up or down.
    if (rst)
      count <= 8'd0;
  end

endmodule
