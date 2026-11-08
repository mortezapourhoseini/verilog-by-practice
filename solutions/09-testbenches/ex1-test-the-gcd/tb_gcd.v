// tb_gcd.v - testbench for gcd.v (solution 09.1).
`timescale 1ns/1ps

module tb_gcd;

  localparam CLK_PERIOD = 10;
  localparam MAX_CYCLES = 5000;    // per GCD; inputs below 1024 need far fewer

  reg         clk;
  reg         rst;
  reg         start;
  reg  [15:0] a_in;
  reg  [15:0] b_in;
  wire [15:0] result;
  wire        done;
  wire        busy;

  integer errors;
  integer tests;
  integer t;

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

  initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
  end

  initial begin
    $dumpfile("tb_gcd.vcd");
    $dumpvars(0, tb_gcd);
    #20000 $dumpoff;   // keep the waveform small
  end

  // Reference model: the modulo form of Euclid's algorithm.
  // It is written differently from the DUT (which subtracts).
  function [15:0] ref_gcd;
    input [15:0] x;
    input [15:0] y;
    reg   [15:0] p, q, r;
    begin
      p = x;
      q = y;
      while (q != 0) begin
        r = p % q;
        p = q;
        q = r;
      end
      ref_gcd = p;
    end
  endfunction

  // Start one computation and wait for done, with a per-run watchdog.
  task run_gcd;
    input [15:0] x;
    input [15:0] y;
    integer cycles;
    begin
      @(negedge clk);
      if (busy) begin
        $display("ERROR: busy is 1 before start");
        errors = errors + 1;
      end
      a_in  = x;
      b_in  = y;
      start = 1'b1;
      @(negedge clk);
      start = 1'b0;
      a_in  = 16'hxxxx;   // the DUT must have copied the inputs
      b_in  = 16'hxxxx;

      cycles = 0;
      while (done !== 1'b1 && cycles < MAX_CYCLES) begin
        @(negedge clk);
        cycles = cycles + 1;
      end

      tests = tests + 1;
      if (done !== 1'b1) begin
        $display("ERROR: gcd(%0d, %0d): no done after %0d cycles", x, y, MAX_CYCLES);
        errors = errors + 1;
      end else if (result !== ref_gcd(x, y)) begin
        $display("ERROR: gcd(%0d, %0d) = %0d, expected %0d", x, y, result, ref_gcd(x, y));
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    tests  = 0;
    rst = 1'b1; start = 1'b0; a_in = 16'd0; b_in = 16'd0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // Directed cases
    run_gcd(0, 0);
    run_gcd(0, 7);
    run_gcd(7, 0);
    run_gcd(12, 8);
    run_gcd(17, 13);
    run_gcd(1024, 48);
    run_gcd(99, 99);
    run_gcd(1, 1000);

    // Random cases below 1024
    for (t = 0; t < 300; t = t + 1)
      run_gcd($random & 16'h03FF, $random & 16'h03FF);

    $display("%0d GCD computations checked", tests);
    if (errors == 0) begin
      $display("PASS: tb_gcd");
      $finish;
    end else begin
      $display("FAIL: tb_gcd (%0d errors)", errors);
      $fatal(1, "tb_gcd failed");
    end
  end

endmodule
