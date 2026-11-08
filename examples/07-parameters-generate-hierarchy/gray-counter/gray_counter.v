// gray_counter.v - a counter whose output is in Gray code.
//
// In Gray code, only ONE bit changes from one value to the next:
//   binary: 000 001 010 011 100 101 110 111
//   gray:   000 001 011 010 110 111 101 100
// This is useful when a value crosses into another clock domain
// (for example the pointers of an asynchronous FIFO).
//
// Shows functions: bin2gray (one line), gray2bin (a loop), and clog2,
// a CONSTANT function used to compute a width from a parameter.
`timescale 1ns/1ps

module gray_counter #(
  parameter MODULO = 16          // counts 0 .. MODULO-1, must be a power of 2
) (
  input  wire                     clk,
  input  wire                     rst,
  input  wire                     en,
  output reg  [clog2(MODULO)-1:0] gray
);

  // Constant function: called with a constant, it is evaluated at
  // elaboration time, so it can set a port width.
  // (Verilog-2005 adds the built-in $clog2. This is the 2001 way.)
  function integer clog2;
    input integer value;
    integer v;
    begin
      v = value - 1;
      clog2 = 0;
      while (v > 0) begin
        clog2 = clog2 + 1;
        v = v >> 1;
      end
    end
  endfunction

  localparam W = clog2(MODULO);

  // Binary -> Gray: each Gray bit is the XOR of two neighbouring binary bits.
  function [W-1:0] bin2gray;
    input [W-1:0] b;
    begin
      bin2gray = b ^ (b >> 1);
    end
  endfunction

  // Gray -> binary: each binary bit is the XOR of all Gray bits above it.
  function [W-1:0] gray2bin;
    input [W-1:0] g;
    integer i;
    begin
      gray2bin[W-1] = g[W-1];
      for (i = W - 2; i >= 0; i = i - 1)
        gray2bin[i] = gray2bin[i+1] ^ g[i];
    end
  endfunction

  // Keep the state in Gray code. To count: decode, add 1, encode.
  always @(posedge clk) begin
    if (rst)
      gray <= {W{1'b0}};
    else if (en)
      gray <= bin2gray(gray2bin(gray) + 1'b1);
  end

endmodule
