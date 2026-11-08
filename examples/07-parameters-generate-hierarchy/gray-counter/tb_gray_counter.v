// tb_gray_counter.v - checks the one-bit-change rule and the full cycle.
`timescale 1ns/1ps

module tb_gray_counter;

  reg        clk;
  reg        rst;
  reg        en;
  wire [3:0] gray16;     // MODULO = 16 -> 4 bits
  wire [5:0] gray64;     // MODULO = 64 -> 6 bits

  reg  [3:0] prev16;
  reg  [5:0] prev64;
  reg  [3:0] bin16;
  integer    errors;
  integer    step;
  integer    k;

  gray_counter #(.MODULO(16)) g16 (.clk(clk), .rst(rst), .en(en), .gray(gray16));
  gray_counter #(.MODULO(64)) g64 (.clk(clk), .rst(rst), .en(en), .gray(gray64));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_gray_counter.vcd");
    $dumpvars(0, tb_gray_counter);
  end

  // Count the 1 bits of a value (a testbench helper function).
  function integer ones;
    input [31:0] v;
    integer i;
    begin
      ones = 0;
      for (i = 0; i < 32; i = i + 1)
        ones = ones + v[i];
    end
  endfunction

  initial begin
    errors = 0;
    rst = 1'b1; en = 1'b0;
    @(negedge clk);
    rst = 1'b0; en = 1'b1;
    prev16 = gray16;
    prev64 = gray64;

    for (step = 1; step <= 128; step = step + 1) begin
      @(negedge clk);

      // Rule 1: exactly one bit changes per step.
      if (ones(gray16 ^ prev16) != 1 || ones(gray64 ^ prev64) != 1) begin
        $display("ERROR: step %0d: %b -> %b, %b -> %b",
                 step, prev16, gray16, prev64, gray64);
        errors = errors + 1;
      end

      // Rule 2: decoding the Gray value gives the step count (mod 16).
      bin16[3] = gray16[3];
      for (k = 2; k >= 0; k = k - 1) bin16[k] = bin16[k+1] ^ gray16[k];
      if (bin16 !== step % 16) begin
        $display("ERROR: step %0d: gray %b decodes to %0d", step, gray16, bin16);
        errors = errors + 1;
      end

      if (step <= 8) $display("step %0d: gray16 = %b", step, gray16);
      prev16 = gray16;
      prev64 = gray64;
    end

    if (errors == 0) begin
      $display("PASS: tb_gray_counter");
      $finish;
    end else begin
      $display("FAIL: tb_gray_counter (%0d errors)", errors);
      $fatal(1, "tb_gray_counter failed");
    end
  end

endmodule
