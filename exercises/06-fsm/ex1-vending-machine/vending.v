// vending.v - 15-cent vending machine, Moore FSM (exercise 06.1).
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

  // TODO: block 1, the state register.

  // TODO: block 2, the next-state logic.
  always @(*) begin
    next = S0;
  end

  // TODO: block 3, the output logic.
  always @(*) begin
    vend   = 1'b0;
    change = 1'b0;
  end

endmodule
