// detect101.v - Mealy FSM that detects 101, with overlap (exercise 06.2).
`timescale 1ns/1ps

module detect101 (
  input  wire clk,
  input  wire rst,
  input  wire din,
  output wire found
);

  // TODO: state encoding, state register, next-state logic, output.
  assign found = 1'b0;

endmodule
