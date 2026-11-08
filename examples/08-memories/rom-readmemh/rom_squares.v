// rom_squares.v - 16 x 8-bit ROM loaded from a hex file.
//
// The contents are in squares.hex (address k holds k*k).
// Synchronous read: the data appears one clock cycle after the address.
// FPGA tools map this style to block RAM (or LUTs for small sizes), and
// most of them also read the $readmemh file during synthesis.
`timescale 1ns/1ps

module rom_squares #(
  parameter INIT_FILE = "squares.hex"
) (
  input  wire       clk,
  input  wire [3:0] addr,
  output reg  [7:0] data
);

  // A memory: 16 words, each 8 bits wide.
  //        word width   number of words
  reg     [7:0]        mem [0:15];

  // Load the file once, at time 0. The path is relative to the folder
  // where the simulator runs.
  initial begin
    $readmemh(INIT_FILE, mem);
  end

  always @(posedge clk)
    data <= mem[addr];

endmodule
