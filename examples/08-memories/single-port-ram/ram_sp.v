// ram_sp.v - single-port RAM with synchronous write and synchronous read.
//
// One address port, used for both reading and writing.
// "Read-first" behaviour: when we write and read the same address in the
// same cycle, dout shows the OLD contents. (Block RAMs on FPGAs can be
// configured as read-first, write-first or no-change.)
//
// This coding style is recognized by FPGA tools as block RAM.
`timescale 1ns/1ps

module ram_sp #(
  parameter DATA_W = 8,
  parameter ADDR_W = 4                    // 2^4 = 16 words
) (
  input  wire              clk,
  input  wire              we,            // write enable
  input  wire [ADDR_W-1:0] addr,
  input  wire [DATA_W-1:0] din,
  output reg  [DATA_W-1:0] dout
);

  localparam DEPTH = 1 << ADDR_W;

  reg [DATA_W-1:0] mem [0:DEPTH-1];

  always @(posedge clk) begin
    if (we)
      mem[addr] <= din;
    dout <= mem[addr];    // reads the value BEFORE this cycle's write
  end

endmodule
