// vending.v - 15-cent vending machine, Moore FSM (solution 06.1).
`timescale 1ns/1ps

module vending (
  input  wire clk,
  input  wire rst,
  input  wire coin5,
  input  wire coin10,
  output reg  vend,
  output reg  change
);

  localparam S0          = 3'd0;
  localparam S5          = 3'd1;
  localparam S10         = 3'd2;
  localparam VEND        = 3'd3;
  localparam VEND_CHANGE = 3'd4;

  reg [2:0] state;
  reg [2:0] next;

  // Block 1: state register.
  always @(posedge clk) begin
    if (rst) state <= S0;
    else     state <= next;
  end

  // Block 2: next-state logic.
  always @(*) begin
    next = state;   // default: no coin, stay
    case (state)
      S0:  if (coin5) next = S5;   else if (coin10) next = S10;
      S5:  if (coin5) next = S10;  else if (coin10) next = VEND;
      S10: if (coin5) next = VEND; else if (coin10) next = VEND_CHANGE;
      VEND:        next = S0;
      VEND_CHANGE: next = S0;
      default:     next = S0;      // illegal codes 5, 6, 7: recover
    endcase
  end

  // Block 3: output logic (Moore).
  always @(*) begin
    vend   = 1'b0;
    change = 1'b0;
    case (state)
      VEND:        vend = 1'b1;
      VEND_CHANGE: begin vend = 1'b1; change = 1'b1; end
      default: ;
    endcase
  end

endmodule
