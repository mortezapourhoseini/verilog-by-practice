// tb_smul8.v - exhaustive test of the signed multiplier.
`timescale 1ns/1ps

module tb_smul8;

  reg  [7:0]  a;
  reg  [7:0]  b;
  wire [15:0] p;

  integer ia, ib, want;
  integer errors;
  integer i, j;

  smul8 dut (.a(a), .b(b), .p(p));

  initial begin
    $dumpfile("tb_smul8.vcd");
    $dumpvars(0, tb_smul8);
    #1000 $dumpoff;
  end

  initial begin
    errors = 0;
    for (i = 0; i < 256; i = i + 1) begin
      for (j = 0; j < 256; j = j + 1) begin
        a = i; b = j;
        #1;
        ia = (i > 127) ? i - 256 : i;
        ib = (j > 127) ? j - 256 : j;
        want = ia * ib;
        if (p !== want[15:0]) begin
          if (errors < 10)
            $display("ERROR: %0d * %0d -> %h, expected %h", ia, ib, p, want[15:0]);
          errors = errors + 1;
        end
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_smul8");
      $finish;
    end else begin
      $display("FAIL: tb_smul8 (%0d errors)", errors);
      $fatal(1, "tb_smul8 failed");
    end
  end

endmodule
