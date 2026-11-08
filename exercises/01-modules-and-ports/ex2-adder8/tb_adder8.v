// tb_adder8.v - self-checking testbench for exercise 01.2.
`timescale 1ns/1ps

module tb_adder8;

  reg  [7:0] a;
  reg  [7:0] b;
  reg        cin;
  wire [7:0] sum;
  wire       cout;

  reg  [8:0] expected;
  integer    errors;
  integer    i;
  integer    j;

  adder8 dut (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum),
    .cout (cout)
  );

  // This test is long, so a full waveform would be large.
  // We record only the first 1000 ns, then stop recording.
  initial begin
    $dumpfile("tb_adder8.vcd");
    $dumpvars(0, tb_adder8);
    #1000 $dumpoff;
  end

  initial begin
    errors = 0;

    // All values of a and b, with cin = 0 and cin = 1: 131072 cases.
    // This takes about one second in Icarus.
    for (i = 0; i < 256; i = i + 1) begin
      for (j = 0; j < 512; j = j + 1) begin
        a   = i[7:0];
        {cin, b} = j[8:0];
        #1;
        expected = a + b + cin;
        if ({cout, sum} !== expected) begin
          if (errors < 10)
            $display("ERROR: %0d + %0d + %0d -> %0d, expected %0d",
                     a, b, cin, {cout, sum}, expected);
          errors = errors + 1;
        end
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_adder8");
      $finish;
    end else begin
      $display("FAIL: tb_adder8 (%0d errors)", errors);
      $fatal(1, "tb_adder8 failed");
    end
  end

endmodule
