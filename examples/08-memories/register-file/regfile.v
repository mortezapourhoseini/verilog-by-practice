// regfile.v - register file like in a small RISC processor.
//
//   8 registers of 8 bits. Register 0 always reads as 0.
//   2 read ports: asynchronous (combinational) read.
//   1 write port: synchronous write.
//
// Asynchronous read is fine for small register files. FPGA tools build
// it from LUTs ("distributed RAM"), not from block RAM.
`timescale 1ns/1ps

module regfile (
  input  wire       clk,
  input  wire       we,
  input  wire [2:0] waddr,
  input  wire [7:0] wdata,
  input  wire [2:0] raddr_a,
  output wire [7:0] rdata_a,
  input  wire [2:0] raddr_b,
  output wire [7:0] rdata_b
);

  reg [7:0] regs [0:7];

  // Simulation-only start values. Real hardware would need a reset or
  // would start with unknown values. (Chapter 10.)
  integer i;
  initial begin
    for (i = 0; i < 8; i = i + 1)
      regs[i] = 8'd0;
  end

  always @(posedge clk) begin
    if (we && waddr != 3'd0)     // writes to register 0 are ignored
      regs[waddr] <= wdata;
  end

  assign rdata_a = (raddr_a == 3'd0) ? 8'd0 : regs[raddr_a];
  assign rdata_b = (raddr_b == 3'd0) ? 8'd0 : regs[raddr_b];

endmodule
