// detect101.v - Mealy FSM that detects 101, with overlap (solution 06.2).
//
// Three states are enough:
//   S0  : nothing useful seen
//   S1  : the last bit was 1
//   S10 : the last bits were 10
// found = 1 when we are in S10 and the input is 1.
// After a match, the final 1 can start a new pattern, so we go to S1.
//
// A Moore version needs a fourth state S101 (output 1 there), and its
// output comes one cycle later.
`timescale 1ns/1ps

module detect101 (
  input  wire clk,
  input  wire rst,
  input  wire din,
  output wire found
);

  localparam S0  = 2'd0;
  localparam S1  = 2'd1;
  localparam S10 = 2'd2;

  reg [1:0] state;
  reg [1:0] next;

  always @(posedge clk) begin
    if (rst) state <= S0;
    else     state <= next;
  end

  always @(*) begin
    case (state)
      S0:      next = din ? S1 : S0;
      S1:      next = din ? S1 : S10;
      S10:     next = din ? S1 : S0;
      default: next = S0;
    endcase
  end

  assign found = (state == S10) && din;

endmodule
