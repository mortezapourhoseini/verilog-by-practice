// edge_detect.v - synchronize an outside signal and detect its edges.
//
// An input from outside the chip (a button, a signal from another clock
// domain) can change at ANY time, also very close to a clock edge. The
// first flip-flop may then become "metastable" for a short time. A second
// flip-flop gives it a full clock period to settle. This two-flop chain
// is called a synchronizer.
//
// After the synchronizer we keep the previous value. Comparing the
// current and the previous value gives one-cycle pulses on edges.
`timescale 1ns/1ps

module edge_detect (
  input  wire clk,
  input  wire rst,
  input  wire async_in,   // may change at any time
  output wire rise,       // 1 for one cycle after a 0 -> 1 change
  output wire fall,       // 1 for one cycle after a 1 -> 0 change
  output wire level       // the synchronized level
);

  reg sync1;
  reg sync2;
  reg prev;

  always @(posedge clk) begin
    if (rst) begin
      sync1 <= 1'b0;
      sync2 <= 1'b0;
      prev  <= 1'b0;
    end else begin
      sync1 <= async_in;   // may go metastable
      sync2 <= sync1;      // settled, safe to use
      prev  <= sync2;      // the value one cycle ago
    end
  end

  assign level = sync2;
  assign rise  =  sync2 & ~prev;
  assign fall  = ~sync2 &  prev;

endmodule
