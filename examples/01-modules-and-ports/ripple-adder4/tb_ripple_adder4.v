// tb_ripple_adder4.v - exhaustive self-checking testbench.
`timescale 1ns/1ps

module tb_ripple_adder4;

  reg  [3:0] a;
  reg  [3:0] b;
  reg        cin;
  wire [3:0] sum;
  wire       cout;

  reg  [4:0] expected;   // {cout, sum}
  integer    errors;
  integer    i;

  ripple_adder4 dut (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum),
    .cout (cout)
  );

  initial begin
    $dumpfile("tb_ripple_adder4.vcd");
    $dumpvars(0, tb_ripple_adder4);
  end

  initial begin
    errors = 0;

    // 4 + 4 + 1 = 9 input bits -> 512 combinations. Test them all.
    for (i = 0; i < 512; i = i + 1) begin
      {cin, b, a} = i[8:0];
      #5;
      expected = a + b + cin;   // 5-bit result, so the carry is kept
      if ({cout, sum} !== expected) begin
        if (errors < 10)
          $display("ERROR: %0d + %0d + %0d -> %0d, expected %0d",
                   a, b, cin, {cout, sum}, expected);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_ripple_adder4");
      $finish;
    end else begin
      $display("FAIL: tb_ripple_adder4 (%0d errors)", errors);
      $fatal(1, "tb_ripple_adder4 failed");
    end
  end

endmodule
