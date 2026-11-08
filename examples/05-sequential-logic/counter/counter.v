// counter.v - 4-bit up counter with synchronous reset and enable.
//
// wrap is a one-cycle pulse that is 1 while count is 15 and en is 1,
// that is, in the cycle before the counter goes back to 0.
// Such a pulse is often used to enable a second, slower counter.
`timescale 1ns/1ps

module counter (
  input  wire       clk,
  input  wire       rst,     // synchronous, active high
  input  wire       en,
  output reg  [3:0] count,
  output wire       wrap
);

  // Sequential part: one register, updated at the clock edge.
  always @(posedge clk) begin
    if (rst)
      count <= 4'd0;
    else if (en)
      count <= count + 4'd1;   // 15 + 1 = 0 in 4 bits: it wraps by itself
  end

  // Combinational part: computed from the current register value.
  assign wrap = en && (count == 4'd15);

endmodule
