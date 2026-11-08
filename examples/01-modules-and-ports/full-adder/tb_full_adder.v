// tb_full_adder.v - self-checking testbench for full_adder.
`timescale 1ns/1ps

module tb_full_adder;

  reg  a;
  reg  b;
  reg  cin;
  wire sum;
  wire cout;

  reg  [1:0] expected;   // {cout, sum}
  integer    errors;
  integer    i;

  full_adder dut (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum),
    .cout (cout)
  );

  initial begin
    $dumpfile("tb_full_adder.vcd");
    $dumpvars(0, tb_full_adder);
  end

  initial begin
    errors = 0;

    for (i = 0; i < 8; i = i + 1) begin
      {a, b, cin} = i[2:0];
      #10;
      expected = a + b + cin;   // 2-bit result: 0, 1, 2 or 3
      if ({cout, sum} !== expected) begin
        $display("ERROR: a=%b b=%b cin=%b -> cout=%b sum=%b, expected %b",
                 a, b, cin, cout, sum, expected);
        errors = errors + 1;
      end
    end

    // A hierarchical name reaches a signal inside the DUT.
    // This is useful for debugging. Do not use it inside a design.
    $display("Last value of the internal wire dut.s0 = %b", dut.s0);

    if (errors == 0) begin
      $display("PASS: tb_full_adder");
      $finish;
    end else begin
      $display("FAIL: tb_full_adder (%0d errors)", errors);
      $fatal(1, "tb_full_adder failed");
    end
  end

endmodule
