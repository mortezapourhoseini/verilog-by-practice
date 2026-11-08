// tb_abs_diff.v - reads test vectors from a file and writes a result file.
//
// File tasks used here (all Verilog-2001):
//   $fopen   open a file, returns a handle (0 means: failed)
//   $fgets   read one line into a string variable
//   $sscanf  read values out of a string
//   $fdisplay write a line to a file
//   $feof    true at the end of the file
//   $fclose  close the file
`timescale 1ns/1ps

module tb_abs_diff;

  reg  [7:0] a;
  reg  [7:0] b;
  wire [7:0] y;

  integer fin;          // input file handle
  integer fout;         // output file handle
  integer n_items;      // how many values $sscanf found
  integer line_no;
  integer tests;
  integer errors;
  reg [8*80:1] line;    // one line of text, up to 80 characters
  reg [7:0]    va, vb, vexp;
  integer      got;

  abs_diff dut (
    .a (a),
    .b (b),
    .y (y)
  );

  initial begin
    $dumpfile("tb_abs_diff.vcd");
    $dumpvars(0, tb_abs_diff);
  end

  initial begin
    errors = 0;
    tests  = 0;
    line_no = 0;

    fin = $fopen("vectors.txt", "r");
    if (fin == 0) begin
      $display("FAIL: tb_abs_diff (cannot open vectors.txt)");
      $fatal(1, "missing input file");
    end
    fout = $fopen("results_out.txt", "w");
    $fdisplay(fout, "// a  b  expected  got  status");

    while (!$feof(fin)) begin
      got = $fgets(line, fin);         // returns the number of characters read
      line_no = line_no + 1;
      // Try to read three hex numbers from the line. Comment lines and
      // empty lines give fewer than 3 items, so we skip them.
      n_items = $sscanf(line, "%h %h %h", va, vb, vexp);
      if (got > 0 && n_items == 3) begin
        a = va;
        b = vb;
        #1;
        tests = tests + 1;
        if (y !== vexp) begin
          $display("ERROR line %0d: |%h - %h| = %h, expected %h", line_no, a, b, y, vexp);
          errors = errors + 1;
          $fdisplay(fout, "%h %h %h %h FAIL", a, b, vexp, y);
        end else begin
          $fdisplay(fout, "%h %h %h %h ok", a, b, vexp, y);
        end
      end
    end

    $fclose(fin);
    $fclose(fout);
    $display("%0d vectors from vectors.txt, results in results_out.txt", tests);

    if (tests == 0) begin
      $display("ERROR: no test vector was read");
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_abs_diff");
      $finish;
    end else begin
      $display("FAIL: tb_abs_diff (%0d errors)", errors);
      $fatal(1, "tb_abs_diff failed");
    end
  end

endmodule
