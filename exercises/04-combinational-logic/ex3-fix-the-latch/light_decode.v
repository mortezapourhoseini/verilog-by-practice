// light_decode.v - traffic light decoder WITH LATCH BUGS (exercise 04.3).
// Find the three places where an output is not assigned, and fix them.
`timescale 1ns/1ps

module light_decode (
  input  wire [1:0] state,
  input  wire       emergency,
  output reg        red,
  output reg        yellow,
  output reg        green
);

  always @(*) begin
    if (emergency) begin
      red = 1'b1;
    end else begin
      case (state)
        2'd0: begin
          red    = 1'b1;
          yellow = 1'b0;
          green  = 1'b0;
        end
        2'd1: begin
          red   = 1'b0;
          green = 1'b1;
        end
        2'd2: begin
          red    = 1'b0;
          yellow = 1'b1;
          green  = 1'b0;
        end
      endcase
    end
  end

endmodule
