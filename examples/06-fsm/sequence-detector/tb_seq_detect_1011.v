// tb_seq_detect_1011.v - compares both detectors with a shift-register model.
`timescale 1ns/1ps

module tb_seq_detect_1011;

  reg  clk;
  reg  rst;
  reg  din;
  wire found_moore;
  wire found_mealy;

  reg  [3:0] hist;   // the last four bits sampled at clock edges
  integer    errors;
  integer    n_moore;
  integer    n_mealy;
  integer    k;
  reg  [15:0] pattern;

  seq_detect_1011_moore u_moore (.clk(clk), .rst(rst), .din(din), .found(found_moore));
  seq_detect_1011_mealy u_mealy (.clk(clk), .rst(rst), .din(din), .found(found_mealy));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_seq_detect_1011.vcd");
    $dumpvars(0, tb_seq_detect_1011);
  end

  // At each rising edge, before the update:
  //  - Moore output must show whether the last 4 SAMPLED bits were 1011.
  //  - Mealy output must show whether the last 3 sampled bits plus the
  //    CURRENT input are 1011.
  always @(posedge clk) begin
    if (rst) begin
      hist <= 4'b0000;
    end else begin
      if (found_moore !== (hist == 4'b1011)) begin
        $display("ERROR at %0t: moore found=%b, history=%b", $time, found_moore, hist);
        errors = errors + 1;
      end
      if (found_mealy !== ({hist[2:0], din} == 4'b1011)) begin
        $display("ERROR at %0t: mealy found=%b, history=%b din=%b", $time, found_mealy, hist, din);
        errors = errors + 1;
      end
      if (found_moore) n_moore = n_moore + 1;
      if (found_mealy) n_mealy = n_mealy + 1;
      hist <= {hist[2:0], din};
    end
  end

  initial begin
    errors = 0; n_moore = 0; n_mealy = 0;
    rst = 1'b1; din = 1'b0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // A directed pattern with two overlapping matches: 1011011
    pattern = 16'b0001_0110_1100_0000;
    for (k = 15; k >= 0; k = k - 1) begin
      din = pattern[k];
      @(negedge clk);
    end
    $display("directed pattern: moore saw %0d, mealy saw %0d (expected 2)", n_moore, n_mealy);
    if (n_moore != 2 || n_mealy != 2) errors = errors + 1;

    // Random bits.
    for (k = 0; k < 2000; k = k + 1) begin
      din = $random;
      @(negedge clk);
    end
    $display("after random bits: moore saw %0d, mealy saw %0d", n_moore, n_mealy);

    if (errors == 0) begin
      $display("PASS: tb_seq_detect_1011");
      $finish;
    end else begin
      $display("FAIL: tb_seq_detect_1011 (%0d errors)", errors);
      $fatal(1, "tb_seq_detect_1011 failed");
    end
  end

endmodule
