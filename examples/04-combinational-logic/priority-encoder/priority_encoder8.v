// priority_encoder8.v - index of the highest request bit that is 1.
//
//   req = 8'b0010_0110  ->  idx = 5, valid = 1
//   req = 8'b0000_0000  ->  idx = 0, valid = 0
//
// Two versions of the same logic are in this file:
//   priority_encoder8      uses a for loop
//   priority_encoder8_casez uses casez with "don't care" bits
// The testbench checks that both agree with a reference model.
`timescale 1ns/1ps

module priority_encoder8 (
  input  wire [7:0] req,
  output reg  [2:0] idx,
  output reg        valid
);

  integer i;

  always @(*) begin
    // Defaults: the values when no request is active.
    idx   = 3'd0;
    valid = 1'b0;

    // The loop is unrolled at compile time into 8 if statements.
    // A later assignment overrides an earlier one, so the HIGHEST
    // active bit wins, because it is checked last.
    for (i = 0; i < 8; i = i + 1) begin
      if (req[i]) begin
        idx   = i;
        valid = 1'b1;
      end
    end
  end

endmodule


module priority_encoder8_casez (
  input  wire [7:0] req,
  output reg  [2:0] idx,
  output reg        valid
);

  // In casez, "?" in a case item means "this bit does not matter".
  // The items are checked from top to bottom, and the first match wins.
  always @(*) begin
    valid = 1'b1;
    casez (req)
      8'b1???_????: idx = 3'd7;
      8'b01??_????: idx = 3'd6;
      8'b001?_????: idx = 3'd5;
      8'b0001_????: idx = 3'd4;
      8'b0000_1???: idx = 3'd3;
      8'b0000_01??: idx = 3'd2;
      8'b0000_001?: idx = 3'd1;
      8'b0000_0001: idx = 3'd0;
      default: begin
        idx   = 3'd0;
        valid = 1'b0;
      end
    endcase
  end

endmodule
