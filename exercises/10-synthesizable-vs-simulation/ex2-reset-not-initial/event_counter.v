// event_counter.v - counts tick pulses (exercise 10.2: fix the reset).
`timescale 1ns/1ps

module event_counter (
  input  wire       clk,
  input  wire       rst,
  input  wire       tick,
  output reg  [7:0] count
);

  // BUG: this works only in simulation, and only once.
  initial count = 8'd0;

  always @(posedge clk) begin
    if (tick)
      count <= count + 8'd1;
  end

endmodule
