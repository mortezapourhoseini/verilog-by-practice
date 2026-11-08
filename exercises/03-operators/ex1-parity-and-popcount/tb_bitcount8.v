// tb_bitcount8.v - exhaustive testbench for exercise 03.1.
`timescale 1ns/1ps

module tb_bitcount8;

  reg  [7:0] d;
  wire       parity;
  wire [3:0] ones;

  integer want_ones;
  integer errors;
  integer i;
  integer k;

  bitcount8 dut (
    .d      (d),
    .parity (parity),
    .ones   (ones)
  );

  initial begin
    $dumpfile("tb_bitcount8.vcd");
    $dumpvars(0, tb_bitcount8);
  end

  initial begin
    errors = 0;

    for (i = 0; i < 256; i = i + 1) begin
      d = i[7:0];
      #2;
      // Reference model: count with a loop.
      want_ones = 0;
      for (k = 0; k < 8; k = k + 1)
        if (d[k]) want_ones = want_ones + 1;

      if (ones !== want_ones || parity !== (want_ones % 2)) begin
        if (errors < 10)
          $display("ERROR: d=%b -> ones=%0d parity=%b, expected %0d %0d",
                   d, ones, parity, want_ones, want_ones % 2);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_bitcount8");
      $finish;
    end else begin
      $display("FAIL: tb_bitcount8 (%0d errors)", errors);
      $fatal(1, "tb_bitcount8 failed");
    end
  end

endmodule
