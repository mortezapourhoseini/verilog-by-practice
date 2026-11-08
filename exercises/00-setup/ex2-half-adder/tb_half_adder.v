// tb_half_adder.v - self-checking testbench for exercise 00.2.
`timescale 1ns/1ps

module tb_half_adder;

  reg  a;
  reg  b;
  wire sum;
  wire carry;

  reg  [1:0] expected;   // {carry, sum}
  integer    errors;
  integer    i;

  half_adder dut (
    .a     (a),
    .b     (b),
    .sum   (sum),
    .carry (carry)
  );

  initial begin
    $dumpfile("tb_half_adder.vcd");
    $dumpvars(0, tb_half_adder);
  end

  initial begin
    errors = 0;

    for (i = 0; i < 4; i = i + 1) begin
      {a, b} = i[1:0];
      #10;
      // The reference model uses the + operator: 1 + 1 = 2'b10.
      expected = a + b;
      if ({carry, sum} !== expected) begin
        $display("ERROR: a=%b b=%b -> carry=%b sum=%b, expected carry=%b sum=%b",
                 a, b, carry, sum, expected[1], expected[0]);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_half_adder");
      $finish;
    end else begin
      $display("FAIL: tb_half_adder (%0d errors)", errors);
      $fatal(1, "tb_half_adder failed");
    end
  end

endmodule
