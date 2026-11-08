// mux4.v - 4-to-1 multiplexer from three mux2 instances (exercise 01.1).
`timescale 1ns/1ps

module mux4 (
  input  wire [3:0] d,
  input  wire [1:0] sel,
  output wire       y
);

  // TODO: declare two internal wires and add three mux2 instances.
  //       Then delete the line below.
  assign y = 1'b0;

endmodule
