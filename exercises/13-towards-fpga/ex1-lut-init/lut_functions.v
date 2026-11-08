// lut_functions.v - four functions, one LUT each (exercise 13.1).
`timescale 1ns/1ps

module lut_functions (
  input  wire [3:0] in,      // in[0] = i0 ... in[3] = i3
  output wire       f_mux,
  output wire       f_and4,
  output wire       f_xor4,
  output wire       f_atleast2
);

  // TODO: replace each 16'h0000 with the correct INIT value.
  lut4 #(.INIT(16'h0000)) l_mux      (.i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .o(f_mux));
  lut4 #(.INIT(16'h0000)) l_and4     (.i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .o(f_and4));
  lut4 #(.INIT(16'h0000)) l_xor4     (.i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .o(f_xor4));
  lut4 #(.INIT(16'h0000)) l_atleast2 (.i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .o(f_atleast2));

endmodule
