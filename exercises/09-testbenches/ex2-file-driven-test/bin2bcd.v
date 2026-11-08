// bin2bcd.v - 8-bit binary to three BCD digits (DUT for exercise 09.2).
//
// Uses the "double dabble" (shift and add 3) algorithm, unrolled by a
// for loop into combinational logic:
//   repeat 8 times:
//     for each BCD digit: if digit >= 5, add 3
//     shift everything left by one
`timescale 1ns/1ps

module bin2bcd (
  input  wire [7:0] bin,
  output reg  [3:0] hundreds,
  output reg  [3:0] tens,
  output reg  [3:0] ones
);

  //          [19:16]   [15:12] [11:8] [7:0]
  // shift = {hundreds, tens,   ones,  binary}
  reg [19:0] shift;
  integer    i;

  always @(*) begin
    shift = {12'd0, bin};
    for (i = 0; i < 8; i = i + 1) begin
      if (shift[11:8]  >= 4'd5) shift[11:8]  = shift[11:8]  + 4'd3;
      if (shift[15:12] >= 4'd5) shift[15:12] = shift[15:12] + 4'd3;
      if (shift[19:16] >= 4'd5) shift[19:16] = shift[19:16] + 4'd3;
      shift = shift << 1;
    end
    hundreds = shift[19:16];
    tens     = shift[15:12];
    ones     = shift[11:8];
  end

endmodule
