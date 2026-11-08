// clz8.v - count leading zeros of a byte (solution 04.2).
`timescale 1ns/1ps

module clz8 (
  input  wire [7:0] d,
  output reg  [3:0] count
);

  integer i;

  always @(*) begin
    count = 4'd8;   // the answer when d is 0
    // Loop from bit 0 UP to bit 7. The last match wins, so the highest
    // 1 bit decides. If bit i is the highest 1, there are 7 - i zeros above it.
    for (i = 0; i < 8; i = i + 1) begin
      if (d[i])
        count = 7 - i;
    end
  end

endmodule
