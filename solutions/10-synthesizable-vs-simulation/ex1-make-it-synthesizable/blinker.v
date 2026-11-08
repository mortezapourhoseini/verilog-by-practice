// blinker.v - LED blinker as synthesizable RTL (solution 10.1).
`timescale 1ns/1ps

module blinker #(
  parameter HALF = 5          // led toggles every HALF clock cycles
) (
  input  wire clk,
  input  wire rst,
  output reg  led
);

  reg [7:0] cnt;

  // The model waits HALF edges, then toggles. The RTL counts 0, 1, ...,
  // HALF-1. At the edge where the counter is HALF-1 (the HALF-th edge),
  // it toggles the LED and starts again from 0.
  always @(posedge clk) begin
    if (rst) begin
      cnt <= 8'd0;
      led <= 1'b0;
    end else if (cnt == HALF - 1) begin
      cnt <= 8'd0;
      led <= ~led;
    end else begin
      cnt <= cnt + 8'd1;
    end
  end

endmodule
