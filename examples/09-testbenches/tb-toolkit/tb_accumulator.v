// tb_accumulator.v - a testbench template with the most useful tools.
//
// Copy this file when you start a new testbench. It shows:
//   - a parameterized clock and a reset task,
//   - driver tasks (send a value, clear),
//   - a checker task with a clear message,
//   - $timeformat and %t, $monitor, $display versus $strobe,
//   - a watchdog timeout,
//   - one PASS/FAIL line and a non-zero exit status on failure.
`timescale 1ns/1ps

module tb_accumulator;

  // ---------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------
  localparam CLK_PERIOD = 10;        // ns
  localparam TIMEOUT    = 100_000;   // ns: stop if the test hangs

  // ---------------------------------------------------------------
  // Signals and DUT
  // ---------------------------------------------------------------
  reg         clk;
  reg         rst;
  reg         clear;
  reg         valid;
  reg  [7:0]  din;
  wire [15:0] sum;

  integer errors;
  integer checks;
  integer expected;     // reference model
  integer k;

  accumulator dut (
    .clk   (clk),
    .rst   (rst),
    .clear (clear),
    .valid (valid),
    .din   (din),
    .sum   (sum)
  );

  // ---------------------------------------------------------------
  // Clock, waveform, watchdog
  // ---------------------------------------------------------------
  initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
  end

  initial begin
    $dumpfile("tb_accumulator.vcd");
    $dumpvars(0, tb_accumulator);
  end

  // If something hangs (for example waiting for a signal that never
  // comes), the watchdog ends the simulation with a clear FAIL.
  initial begin
    #(TIMEOUT);
    $display("FAIL: tb_accumulator (timeout after %0d ns)", TIMEOUT);
    $fatal(1, "timeout");
  end

  // ---------------------------------------------------------------
  // Tasks: drivers and checkers
  // ---------------------------------------------------------------

  // Hold reset for n clock cycles. Inputs change on the falling edge.
  task reset_dut;
    input integer n;
    begin
      rst = 1'b1; clear = 1'b0; valid = 1'b0; din = 8'd0;
      repeat (n) @(negedge clk);
      rst = 1'b0;
      expected = 0;
    end
  endtask

  // Send one value: valid is 1 for exactly one cycle.
  task send;
    input [7:0] value;
    begin
      valid = 1'b1;
      din   = value;
      @(negedge clk);
      valid = 1'b0;
      din   = 8'hxx;              // x outside valid cycles finds sloppy DUTs
      expected = (expected + value) % 65536;
    end
  endtask

  task do_clear;
    begin
      clear = 1'b1;
      @(negedge clk);
      clear = 1'b0;
      expected = 0;
    end
  endtask

  // Compare the DUT output with the model, with a helpful message.
  task check_sum;
    input [8*32:1] where;
    begin
      checks = checks + 1;
      if (sum !== expected[15:0]) begin
        $display("ERROR at %t (%0s): sum = %0d, expected %0d",
                 $time, where, sum, expected);
        errors = errors + 1;
      end
    end
  endtask

  // ---------------------------------------------------------------
  // The test
  // ---------------------------------------------------------------
  initial begin
    errors = 0;
    checks = 0;
    // Print %t as nanoseconds with one decimal: units -9 (ns),
    // 1 digit after the point, suffix " ns", minimum width 10.
    $timeformat(-9, 1, " ns", 10);

    reset_dut(2);
    check_sum("after reset");

    // $monitor prints a line every time one of its signals changes.
    // Useful for a quick look, too noisy for long tests.
    $monitor("monitor: %t  valid=%b din=%h sum=%0d", $time, valid, din, sum);
    send(8'd10);
    send(8'd20);
    send(8'd30);
    check_sum("after 10+20+30");
    $monitoroff;

    // $display versus $strobe at a clock edge.
    valid = 1'b1; din = 8'd1;
    @(posedge clk);
    $display("at the edge, $display sees the OLD sum: %0d", sum);
    $strobe ("at the edge, $strobe  sees the NEW sum: %0d", sum);
    @(negedge clk);
    valid = 1'b0;
    expected = expected + 1;
    check_sum("after the strobe demo");

    // Clear in the middle.
    do_clear;
    check_sum("after clear");

    // Many random values, including overflow past 65535.
    for (k = 0; k < 600; k = k + 1) begin
      send($random);
      check_sum("random");
    end

    // Gaps: valid = 0 must not change the sum.
    repeat (5) @(negedge clk);
    check_sum("after idle cycles");

    // ---------------------------------------------------------------
    // Final report: exactly one PASS or FAIL line.
    // ---------------------------------------------------------------
    $display("%0d checks, %0d errors", checks, errors);
    if (errors == 0) begin
      $display("PASS: tb_accumulator");
      $finish;
    end else begin
      $display("FAIL: tb_accumulator (%0d errors)", errors);
      $fatal(1, "tb_accumulator failed");
    end
  end

endmodule
