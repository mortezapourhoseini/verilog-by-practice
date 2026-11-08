// tb_dff_variants.v - shows how the four flip-flop kinds behave.
`timescale 1ns/1ps

module tb_dff_variants;

  reg  clk;
  reg  rst;      // active high, for the synchronous versions
  reg  rst_n;    // active low, for the asynchronous version
  reg  en;
  reg  d;
  wire q_plain;
  wire q_sync;
  wire q_async;
  wire q_en;

  integer errors;

  dff             u_plain (.clk(clk), .d(d), .q(q_plain));
  dff_sync_reset  u_sync  (.clk(clk), .rst(rst), .d(d), .q(q_sync));
  dff_async_reset u_async (.clk(clk), .rst_n(rst_n), .d(d), .q(q_async));
  dff_enable      u_en    (.clk(clk), .rst(rst), .en(en), .d(d), .q(q_en));

  // Clock: period 10 ns. Rising edges at 5, 15, 25, ...
  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_dff_variants.vcd");
    $dumpvars(0, tb_dff_variants);
  end

  task expect_bit;
    input          got;
    input          want;
    input [8*48:1] what;
    begin
      if (got !== want) begin
        $display("ERROR at %0d ns: %0s: got %b, expected %b", $time, what, got, want);
        errors = errors + 1;
      end else begin
        $display("ok    at %0d ns: %0s = %b", $time, what, got);
      end
    end
  endtask

  initial begin
    errors = 0;
    rst = 1'b0; rst_n = 1'b1; en = 1'b1; d = 1'b0;

    // Before the first clock edge, no flip-flop has a value yet.
    #1;
    expect_bit(q_plain, 1'bx, "before any clock edge, q_plain");

    // Drive inputs on the FALLING edge, so they are stable at the
    // rising edge. This avoids races (chapter 11).
    @(negedge clk);  d = 1'b1;
    @(negedge clk);
    expect_bit(q_plain, 1'b1, "after a rising edge, q_plain = d");
    expect_bit(q_sync,  1'b1, "q_sync = d");
    expect_bit(q_async, 1'b1, "q_async = d");

    // ---- Synchronous vs asynchronous reset ----
    // At t = 22 (between edges) assert both resets.
    #2;
    rst = 1'b1; rst_n = 1'b0;
    #1;   // t = 23: no clock edge yet
    expect_bit(q_sync,  1'b1, "sync reset, before the clock edge");
    expect_bit(q_async, 1'b0, "async reset, cleared at once");
    @(posedge clk); #1;   // t = 26: after the edge
    expect_bit(q_sync,  1'b0, "sync reset, after the clock edge");
    expect_bit(q_en,    1'b0, "q_en reset");

    // Release the resets.
    @(negedge clk); rst = 1'b0; rst_n = 1'b1;

    // ---- Clock enable ----
    en = 1'b0; d = 1'b1;
    @(negedge clk);
    expect_bit(q_en,    1'b0, "en=0: q_en keeps 0");
    expect_bit(q_plain, 1'b1, "q_plain follows d");
    en = 1'b1;
    @(negedge clk);
    expect_bit(q_en,    1'b1, "en=1: q_en takes d");
    en = 1'b0; d = 1'b0;
    @(negedge clk);
    expect_bit(q_en,    1'b1, "en=0: q_en keeps 1");

    if (errors == 0) begin
      $display("PASS: tb_dff_variants");
      $finish;
    end else begin
      $display("FAIL: tb_dff_variants (%0d errors)", errors);
      $fatal(1, "tb_dff_variants failed");
    end
  end

endmodule
