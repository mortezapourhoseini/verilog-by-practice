// ram_be.v - 16 x 32-bit RAM with byte enables (exercise 08.1).
`timescale 1ns/1ps

module ram_be (
  input  wire        clk,
  input  wire [3:0]  be,
  input  wire [3:0]  addr,
  input  wire [31:0] din,
  output reg  [31:0] dout
);

  reg [31:0] mem [0:15];

  always @(posedge clk) begin
    // TODO: write only the bytes selected by be.
    // This stub writes the WHOLE word when any enable is set.
    if (|be)
      mem[addr] <= din;
    dout <= mem[addr];
  end

endmodule
