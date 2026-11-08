// tb_bcd.v - file-driven testbench for bin2bcd (solution 09.2).
`timescale 1ns/1ps

module tb_bcd;

  reg  [7:0] bin;
  wire [3:0] hundreds;
  wire [3:0] tens;
  wire [3:0] ones;

  integer fin;
  integer fout;
  integer got;
  integer n;
  integer value, h, t, o;
  integer vectors;
  integer errors;
  reg [8*80:1] line;

  bin2bcd dut (
    .bin      (bin),
    .hundreds (hundreds),
    .tens     (tens),
    .ones     (ones)
  );

  initial begin
    $dumpfile("tb_bcd.vcd");
    $dumpvars(0, tb_bcd);
  end

  initial begin
    errors  = 0;
    vectors = 0;

    fin = $fopen("bcd_vectors.txt", "r");
    if (fin == 0) begin
      $display("FAIL: tb_bcd (cannot open bcd_vectors.txt)");
      $fatal(1, "missing input file");
    end
    fout = $fopen("bcd_out.txt", "w");

    while (!$feof(fin)) begin
      got = $fgets(line, fin);
      n   = $sscanf(line, "%d %d %d %d", value, h, t, o);
      if (got > 0 && n == 4) begin
        bin = value;
        #1;
        vectors = vectors + 1;
        $fdisplay(fout, "%0d %0d %0d %0d", bin, hundreds, tens, ones);
        if (hundreds !== h || tens !== t || ones !== o) begin
          if (errors < 10)
            $display("ERROR: %0d -> %0d %0d %0d, expected %0d %0d %0d",
                     bin, hundreds, tens, ones, h, t, o);
          errors = errors + 1;
        end
      end
    end
    $fclose(fin);
    $fclose(fout);

    $display("%0d vectors checked", vectors);
    if (vectors != 256) begin
      $display("ERROR: expected 256 vectors");
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_bcd");
      $finish;
    end else begin
      $display("FAIL: tb_bcd (%0d errors)", errors);
      $fatal(1, "tb_bcd failed");
    end
  end

endmodule
