// event_counter.v - counts tick pulses (solution 10.2).
`timescale 1ns/1ps

module event_counter (
  input  wire       clk,
  input  wire       rst,
  input  wire       tick,
  output reg  [7:0] count
);

  // No initial block. The reset defines the start value, every time
  // the system is reset, on every technology.
  always @(posedge clk) begin
    if (rst)
      count <= 8'd0;
    else if (tick)
      count <= count + 8'd1;
  end

endmodule
