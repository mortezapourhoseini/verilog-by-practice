// tb_bcd.v - file-driven testbench for bin2bcd (exercise 09.2: YOU write this).
`timescale 1ns/1ps

module tb_bcd;

  reg  [7:0] bin;
  wire [3:0] hundreds;
  wire [3:0] tens;
  wire [3:0] ones;

  integer errors;

  bin2bcd dut (
    .bin      (bin),
    .hundreds (hundreds),
    .tens     (tens),
    .ones     (ones)
  );

  initial begin
    errors = 1;   // TODO: start with 0 when your test is written

    // TODO: open bcd_vectors.txt, read every line, apply and compare,
    //       count the vectors (expect 256).

    if (errors == 0) begin
      $display("PASS: tb_bcd");
      $finish;
    end else begin
      $display("FAIL: tb_bcd (testbench not written yet)");
      $fatal(1, "tb_bcd failed");
    end
  end

endmodule
