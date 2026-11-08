// blinker.v - LED blinker as synthesizable RTL (exercise 10.1).
`timescale 1ns/1ps

module blinker #(
  parameter HALF = 5          // led toggles every HALF clock cycles
) (
  input  wire clk,
  input  wire rst,
  output reg  led
);

  reg [7:0] cnt;

  // TODO: write the counter and the toggle.
  always @(posedge clk) begin
    if (rst) begin
      cnt <= 8'd0;
      led <= 1'b0;
    end
  end

endmodule
