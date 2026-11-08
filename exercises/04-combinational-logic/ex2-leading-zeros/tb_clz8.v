// tb_clz8.v - exhaustive testbench for exercise 04.2.
`timescale 1ns/1ps

module tb_clz8;

  reg  [7:0] d;
  wire [3:0] count;

  integer want;
  integer errors;
  integer i;

  clz8 dut (
    .d     (d),
    .count (count)
  );

  initial begin
    $dumpfile("tb_clz8.vcd");
    $dumpvars(0, tb_clz8);
  end

  initial begin
    errors = 0;

    for (i = 0; i < 256; i = i + 1) begin
      d = i[7:0];
      #2;
      // Reference model: shift left until the MSB is 1.
      want = 0;
      while (want < 8 && ((d << want) & 8'h80) == 0)
        want = want + 1;

      if (count !== want) begin
        if (errors < 10)
          $display("ERROR: d=%b -> count=%0d, expected %0d", d, count, want);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_clz8");
      $finish;
    end else begin
      $display("FAIL: tb_clz8 (%0d errors)", errors);
      $fatal(1, "tb_clz8 failed");
    end
  end

endmodule
