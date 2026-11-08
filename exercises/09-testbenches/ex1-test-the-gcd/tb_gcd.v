// tb_gcd.v - testbench for gcd.v (exercise 09.1: YOU write this file).
`timescale 1ns/1ps

module tb_gcd;

  reg         clk;
  reg         rst;
  reg         start;
  reg  [15:0] a_in;
  reg  [15:0] b_in;
  wire [15:0] result;
  wire        done;
  wire        busy;

  integer errors;

  gcd dut (
    .clk    (clk),
    .rst    (rst),
    .start  (start),
    .a_in   (a_in),
    .b_in   (b_in),
    .result (result),
    .done   (done),
    .busy   (busy)
  );

  // TODO: clock, waveform dump, watchdog
  // TODO: function ref_gcd
  // TODO: task run_gcd

  initial begin
    errors = 1;   // TODO: start with 0 when your tests are written
    // TODO: reset, directed tests, random tests

    if (errors == 0) begin
      $display("PASS: tb_gcd");
      $finish;
    end else begin
      $display("FAIL: tb_gcd (testbench not written yet)");
      $fatal(1, "tb_gcd failed");
    end
  end

endmodule
