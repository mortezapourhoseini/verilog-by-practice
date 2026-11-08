// fifo8.v - synchronous FIFO, 8 entries of 8 bits (exercise 08.2).
`timescale 1ns/1ps

module fifo8 (
  input  wire       clk,
  input  wire       rst,
  input  wire       wr_en,
  input  wire [7:0] din,
  input  wire       rd_en,
  output reg  [7:0] dout,
  output wire       full,
  output wire       empty,
  output reg  [3:0] count
);

  reg [7:0] mem [0:7];
  reg [2:0] wr_ptr;
  reg [2:0] rd_ptr;

  // TODO: write the pointer, count, memory and dout logic.
  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 3'd0;
      rd_ptr <= 3'd0;
      count  <= 4'd0;
      dout   <= 8'd0;
    end
  end

  assign full  = (count == 4'd8);
  assign empty = (count == 4'd0);

endmodule
