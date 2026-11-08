// tb_detect101.v - testbench for exercise 06.2.
`timescale 1ns/1ps

module tb_detect101;

  reg  clk;
  reg  rst;
  reg  din;
  wire found;

  reg  [1:0]  hist;     // the last two sampled bits
  reg  [15:0] pattern;
  integer     count;
  integer     errors;
  integer     k;

  detect101 dut (
    .clk   (clk),
    .rst   (rst),
    .din   (din),
    .found (found)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_detect101.vcd");
    $dumpvars(0, tb_detect101);
  end

  // Mealy check: last two sampled bits plus the current input.
  always @(posedge clk) begin
    if (rst) begin
      hist <= 2'b00;
    end else begin
      if (found !== ({hist, din} == 3'b101)) begin
        if (errors < 10)
          $display("ERROR at %0t: found=%b, history=%b din=%b", $time, found, hist, din);
        errors = errors + 1;
      end
      if (found) count = count + 1;
      hist <= {hist[0], din};
    end
  end

  initial begin
    errors = 0; count = 0;
    rst = 1'b1; din = 1'b0;
    repeat (2) @(negedge clk);
    rst = 1'b0;

    // Directed: 1010110100 has three matches (two overlap).
    pattern = 16'b1010_1101_0000_0000;
    for (k = 15; k >= 0; k = k - 1) begin
      din = pattern[k];
      @(negedge clk);
    end
    $display("directed pattern: %0d matches (expected 3)", count);
    if (count != 3) errors = errors + 1;

    for (k = 0; k < 3000; k = k + 1) begin
      din = $random;
      @(negedge clk);
    end

    if (errors == 0) begin
      $display("PASS: tb_detect101");
      $finish;
    end else begin
      $display("FAIL: tb_detect101 (%0d errors)", errors);
      $fatal(1, "tb_detect101 failed");
    end
  end

endmodule
