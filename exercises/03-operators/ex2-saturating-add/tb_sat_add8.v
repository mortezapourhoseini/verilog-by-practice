// tb_sat_add8.v - exhaustive testbench for exercise 03.2.
`timescale 1ns/1ps

module tb_sat_add8;

  reg  [7:0] a;
  reg  [7:0] b;
  wire [7:0] usum;
  wire [7:0] ssum;

  integer ua, ub, us;   // unsigned values as integers
  integer sa, sb, ss;   // signed values as integers
  reg  [7:0] want_u;
  reg  [7:0] want_s;
  integer errors;
  integer i;
  integer j;

  sat_add8 dut (
    .a    (a),
    .b    (b),
    .usum (usum),
    .ssum (ssum)
  );

  initial begin
    $dumpfile("tb_sat_add8.vcd");
    $dumpvars(0, tb_sat_add8);
    #1000 $dumpoff;   // 65536 cases: record only the start
  end

  initial begin
    errors = 0;

    for (i = 0; i < 256; i = i + 1) begin
      for (j = 0; j < 256; j = j + 1) begin
        a = i[7:0];
        b = j[7:0];
        #1;
        // Reference model with integers and clamping.
        ua = i;
        ub = j;
        us = ua + ub;
        if (us > 255) us = 255;
        want_u = us;

        sa = (i > 127) ? i - 256 : i;
        sb = (j > 127) ? j - 256 : j;
        ss = sa + sb;
        if (ss > 127)  ss = 127;
        if (ss < -128) ss = -128;
        want_s = ss;   // the low 8 bits of a negative integer = two's complement

        if (usum !== want_u || ssum !== want_s) begin
          if (errors < 10)
            $display("ERROR: a=%0d b=%0d (signed %0d %0d) -> usum=%0d ssum=%h, expected %0d %h",
                     a, b, sa, sb, usum, ssum, want_u, want_s);
          errors = errors + 1;
        end
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_sat_add8");
      $finish;
    end else begin
      $display("FAIL: tb_sat_add8 (%0d errors)", errors);
      $fatal(1, "tb_sat_add8 failed");
    end
  end

endmodule
