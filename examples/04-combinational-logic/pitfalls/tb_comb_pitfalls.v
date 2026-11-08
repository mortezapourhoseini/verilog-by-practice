// tb_comb_pitfalls.v - shows the behaviour of the buggy and fixed blocks.
//
// This testbench PASSES when the bugs behave exactly as chapter 04
// explains. So it checks the explanation, not a "correct" design.
`timescale 1ns/1ps

module tb_comb_pitfalls;

  reg  en;
  reg  d;
  wire q_bad;
  wire q_fixed;

  reg  a;
  reg  b;
  reg  sel;
  wire y_bad;
  wire y_good;

  integer errors;

  latch_bad     u_latch_bad   (.en(en), .d(d), .q(q_bad));
  latch_fixed   u_latch_fixed (.en(en), .d(d), .q(q_fixed));
  mux_bad_sens  u_mux_bad     (.a(a), .b(b), .sel(sel), .y(y_bad));
  mux_good_sens u_mux_good    (.a(a), .b(b), .sel(sel), .y(y_good));

  initial begin
    $dumpfile("tb_comb_pitfalls.vcd");
    $dumpvars(0, tb_comb_pitfalls);
  end

  task expect_bit;
    input          got;
    input          want;
    input [8*50:1] what;
    begin
      if (got !== want) begin
        $display("ERROR: %0s: got %b, expected %b", what, got, want);
        errors = errors + 1;
      end else begin
        $display("ok    %0s: %b", what, got);
      end
    end
  endtask

  initial begin
    errors = 0;

    // ---- Bug 1: latch ----
    en = 1; d = 1;
    #10;
    expect_bit(q_bad,   1'b1, "en=1 d=1: latch_bad follows d");
    expect_bit(q_fixed, 1'b1, "en=1 d=1: latch_fixed follows d");

    en = 0;
    #10;
    d = 0;   // d changes while en = 0
    #10;
    expect_bit(q_bad,   1'b1, "en=0: latch_bad HOLDS the old 1 (a latch)");
    expect_bit(q_fixed, 1'b0, "en=0: latch_fixed gives 0");

    // ---- Bug 2: sensitivity list ----
    a = 0; b = 1; sel = 0;
    #10;
    expect_bit(y_bad,  1'b0, "sel=0: mux_bad_sens = a");
    expect_bit(y_good, 1'b0, "sel=0: mux_good_sens = a");

    sel = 1;   // only sel changes
    #10;
    expect_bit(y_bad,  1'b0, "sel=1: mux_bad_sens did NOT update (bug)");
    expect_bit(y_good, 1'b1, "sel=1: mux_good_sens = b");

    a = 1;     // now a changes, so the bad block finally runs
    #10;
    expect_bit(y_bad,  1'b1, "a changed: mux_bad_sens updates late");

    if (errors == 0) begin
      $display("PASS: tb_comb_pitfalls");
      $finish;
    end else begin
      $display("FAIL: tb_comb_pitfalls (%0d errors)", errors);
      $fatal(1, "tb_comb_pitfalls failed");
    end
  end

endmodule
