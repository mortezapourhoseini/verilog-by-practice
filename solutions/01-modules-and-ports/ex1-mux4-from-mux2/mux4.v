// mux4.v - 4-to-1 multiplexer from three mux2 instances (solution 01.1).
`timescale 1ns/1ps

module mux4 (
  input  wire [3:0] d,
  input  wire [1:0] sel,
  output wire       y
);

  wire lo;   // d[0] or d[1], chosen by sel[0]
  wire hi;   // d[2] or d[3], chosen by sel[0]

  mux2 m_lo  (.a(d[0]), .b(d[1]), .sel(sel[0]), .y(lo));
  mux2 m_hi  (.a(d[2]), .b(d[3]), .sel(sel[0]), .y(hi));
  mux2 m_out (.a(lo),   .b(hi),   .sel(sel[1]), .y(y));

endmodule
