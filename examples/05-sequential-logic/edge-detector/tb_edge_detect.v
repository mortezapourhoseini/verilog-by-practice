// tb_edge_detect.v - checks pulse count, pulse width and latency.
`timescale 1ns/1ps

module tb_edge_detect;

  reg  clk;
  reg  rst;
  reg  async_in;
  wire rise;
  wire fall;
  wire level;

  integer rises;
  integer falls;
  integer errors;
  integer t_change;
  integer t_rise;

  edge_detect dut (
    .clk      (clk),
    .rst      (rst),
    .async_in (async_in),
    .rise     (rise),
    .fall     (fall),
    .level    (level)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_edge_detect.vcd");
    $dumpvars(0, tb_edge_detect);
  end

  // Count pulses at every rising edge (before the registers update).
  always @(posedge clk) begin
    if (!rst) begin
      if (rise) rises = rises + 1;
      if (fall) falls = falls + 1;
      if (rise && fall) begin
        $display("ERROR: rise and fall at the same time");
        errors = errors + 1;
      end
    end
  end

  // Remember the time of the FIRST rise pulse.
  always @(posedge rise) if (t_rise == 0) t_rise = $time;

  initial begin
    errors = 0; rises = 0; falls = 0; t_rise = 0;
    rst = 1'b1;
    async_in = 1'b0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // Change the input at "odd" times, not aligned with the clock.
    #13 async_in = 1'b1;  t_change = $time;
    #47 async_in = 1'b0;
    #31 async_in = 1'b1;
    #22 async_in = 1'b0;
    #3;
    repeat (5) @(negedge clk);

    $display("rises=%0d falls=%0d", rises, falls);
    if (rises != 2 || falls != 2) begin
      $display("ERROR: expected 2 rises and 2 falls");
      errors = errors + 1;
    end

    // The rise pulse starts at the 2nd clock edge after the change:
    // between 1 and 2 clock periods later, depending on where in the
    // period the input changed. Here: change at 33 ns, edges at 35 and 45.
    $display("latency of the first rise: %0d ns", t_rise - t_change);
    if (t_rise - t_change <= 10 || t_rise - t_change > 20) begin
      $display("ERROR: latency should be more than 1 and at most 2 periods");
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_edge_detect");
      $finish;
    end else begin
      $display("FAIL: tb_edge_detect (%0d errors)", errors);
      $fatal(1, "tb_edge_detect failed");
    end
  end

endmodule
