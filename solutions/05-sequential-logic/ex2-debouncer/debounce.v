// debounce.v - button debouncer (solution 05.2).
//
// On real hardware, pass btn_in through a two-flop synchronizer first
// (see examples/05-sequential-logic/edge-detector).
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
    if (rst) begin
      btn_out <= 1'b0;
      cnt     <= 2'd0;
    end else if (btn_in == btn_out) begin
      cnt <= 2'd0;                 // no change wanted: restart the count
    end else if (cnt == STABLE - 1) begin
      btn_out <= btn_in;           // stable long enough: accept it
      cnt     <= 2'd0;
    end else begin
      cnt <= cnt + 2'd1;           // different, but not long enough yet
    end
  end

endmodule
