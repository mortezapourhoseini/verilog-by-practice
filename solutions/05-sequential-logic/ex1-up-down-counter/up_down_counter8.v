// up_down_counter8.v - up/down counter with load (solution 05.1).
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
    if (rst)
      count <= 8'd0;
    else if (load)
      count <= load_value;
    else if (en) begin
      if (up)
        count <= count + 8'd1;   // 255 + 1 wraps to 0 in 8 bits
      else
        count <= count - 8'd1;   // 0 - 1 wraps to 255 in 8 bits
    end
  end

endmodule
