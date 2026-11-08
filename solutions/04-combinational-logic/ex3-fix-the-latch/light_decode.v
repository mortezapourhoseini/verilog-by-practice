// light_decode.v - traffic light decoder, latches fixed (solution 04.3).
//
// The three bugs were:
//   1. emergency branch: yellow and green were not assigned,
//   2. state 1: yellow was not assigned,
//   3. state 3: no case item, so nothing was assigned.
// Default values at the top fix all three at once, and protect
// against new bugs when someone edits the case later.
`timescale 1ns/1ps

module light_decode (
  input  wire [1:0] state,
  input  wire       emergency,
  output reg        red,
  output reg        yellow,
  output reg        green
);

  always @(*) begin
    // Defaults: all lights off.
    red    = 1'b0;
    yellow = 1'b0;
    green  = 1'b0;

    if (emergency) begin
      red = 1'b1;
    end else begin
      case (state)
        2'd0:    red    = 1'b1;
        2'd1:    green  = 1'b1;
        2'd2:    yellow = 1'b1;
        default: ;              // state 3: all off (the defaults)
      endcase
    end
  end

endmodule
