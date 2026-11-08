// lut_functions.v - four functions, one LUT each (solution 13.1).
//
// Truth tables (n = {i3,i2,i1,i0}), output written from n = 15 down to 0:
//
//   f_mux = i2 ? i1 : i0      rows 7..0: 1100_1010 = CA, repeated -> CACA
//   f_and4                    only row 15 is 1           -> 8000
//   f_xor4                    rows with an odd number of 1s:
//                             0110_1001_1001_0110        -> 6996
//   f_atleast2                rows 3,5,6,7,9,10,11,12,13,14,15:
//                             1111_1110_1110_1000        -> FEE8
`timescale 1ns/1ps

module lut_functions (
  input  wire [3:0] in,      // in[0] = i0 ... in[3] = i3
  output wire       f_mux,
  output wire       f_and4,
  output wire       f_xor4,
  output wire       f_atleast2
);

  lut4 #(.INIT(16'hCACA)) l_mux      (.i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .o(f_mux));
  lut4 #(.INIT(16'h8000)) l_and4     (.i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .o(f_and4));
  lut4 #(.INIT(16'h6996)) l_xor4     (.i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .o(f_xor4));
  lut4 #(.INIT(16'hFEE8)) l_atleast2 (.i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .o(f_atleast2));

endmodule
