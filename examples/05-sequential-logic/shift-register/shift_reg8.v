// shift_reg8.v - 8-bit shift register: serial in, parallel out, serial out.
//
// At every enabled clock edge, all bits move one place to the left, and
// serial_in enters at bit 0. After 8 shifts, the first bit that went in
// is at bit 7 and appears on serial_out.
//
// load = 1 copies parallel_in into the register instead (it has priority).
`timescale 1ns/1ps

module shift_reg8 (
  input  wire       clk,
  input  wire       rst,
  input  wire       en,
  input  wire       load,
  input  wire [7:0] parallel_in,
  input  wire       serial_in,
  output reg  [7:0] q,
  output wire       serial_out
);

  always @(posedge clk) begin
    if (rst)
      q <= 8'd0;
    else if (load)
      q <= parallel_in;
    else if (en)
      q <= {q[6:0], serial_in};   // shift left by concatenation
  end

  assign serial_out = q[7];

endmodule
