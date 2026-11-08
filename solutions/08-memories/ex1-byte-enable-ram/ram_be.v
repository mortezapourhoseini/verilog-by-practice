// ram_be.v - 16 x 32-bit RAM with byte enables (solution 08.1).
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
    // One write per byte lane. A part select on a memory word is allowed
    // in Verilog-2001. FPGA tools map this pattern to block RAM with
    // byte-write enables.
    if (be[0]) mem[addr][ 7: 0] <= din[ 7: 0];
    if (be[1]) mem[addr][15: 8] <= din[15: 8];
    if (be[2]) mem[addr][23:16] <= din[23:16];
    if (be[3]) mem[addr][31:24] <= din[31:24];
    dout <= mem[addr];   // read-first: the old word
  end

endmodule
