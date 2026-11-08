// fifo8.v - synchronous FIFO, 8 entries of 8 bits (solution 08.2).
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
  reg [2:0] wr_ptr;   // next free slot. 3 bits: 7 + 1 wraps to 0.
  reg [2:0] rd_ptr;   // oldest entry

  assign full  = (count == 4'd8);
  assign empty = (count == 4'd0);

  // Decide from the state before the edge.
  wire do_write = wr_en && !full;
  wire do_read  = rd_en && !empty;

  always @(posedge clk) begin
    if (rst) begin
      wr_ptr <= 3'd0;
      rd_ptr <= 3'd0;
      count  <= 4'd0;
      dout   <= 8'd0;
    end else begin
      if (do_write) begin
        mem[wr_ptr] <= din;
        wr_ptr      <= wr_ptr + 3'd1;
      end
      if (do_read) begin
        dout   <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 3'd1;
      end
      // Both, one or none: the count changes by +1, -1 or 0.
      case ({do_write, do_read})
        2'b10:   count <= count + 4'd1;
        2'b01:   count <= count - 4'd1;
        default: count <= count;
      endcase
    end
  end

endmodule
