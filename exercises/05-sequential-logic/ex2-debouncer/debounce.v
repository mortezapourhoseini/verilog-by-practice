// debounce.v - button debouncer (exercise 05.2).
`timescale 1ns/1ps

module debounce (
  input  wire clk,
  input  wire rst,
  input  wire btn_in,
  output reg  btn_out
);

  localparam STABLE = 4;   // the input must differ for this many edges

  reg [1:0] cnt;

  always @(posedge clk) begin
    // TODO: write the four rules from the README.
    // This stub copies the input directly: it does not filter bounces.
    if (rst) begin
      btn_out <= 1'b0;
      cnt     <= 2'd0;
    end else begin
      btn_out <= btn_in;
    end
  end

endmodule
