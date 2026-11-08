// gcd.v - greatest common divisor, multi-cycle (DUT for exercise 09.1).
//
// Protocol:
//   1. When busy is 0, set a_in and b_in and pulse start for one cycle.
//   2. busy is 1 while the unit works. It takes a variable number of cycles.
//   3. done is a 1-cycle pulse. result is valid in that cycle and stays
//      valid until the next start.
//
// Algorithm (subtraction form of Euclid):
//   while (b != 0): if (a >= b) a = a - b; else swap(a, b)
//   result = a
// gcd(x, 0) = x, gcd(0, 0) = 0.
`timescale 1ns/1ps

module gcd (
  input  wire        clk,
  input  wire        rst,
  input  wire        start,
  input  wire [15:0] a_in,
  input  wire [15:0] b_in,
  output reg  [15:0] result,
  output reg         done,
  output wire        busy
);

  reg [15:0] a;
  reg [15:0] b;
  reg        running;

  assign busy = running;

  always @(posedge clk) begin
    done <= 1'b0;                      // default: no pulse
    if (rst) begin
      running <= 1'b0;
      a       <= 16'd0;
      b       <= 16'd0;
      result  <= 16'd0;
    end else if (!running) begin
      if (start) begin
        a       <= a_in;
        b       <= b_in;
        running <= 1'b1;
      end
    end else begin
      if (b == 16'd0) begin
        result  <= a;
        done    <= 1'b1;
        running <= 1'b0;
      end else if (a >= b) begin
        a <= a - b;
      end else begin
        a <= b;                        // swap (non-blocking: both use old values)
        b <= a;
      end
    end
  end

endmodule
