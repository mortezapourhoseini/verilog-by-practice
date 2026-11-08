// tb_mux4.v - self-checking testbench for exercise 01.1.
`timescale 1ns/1ps

module tb_mux4;

  reg  [3:0] d;
  reg  [1:0] sel;
  wire       y;

  integer errors;
  integer i;

  mux4 dut (
    .d   (d),
    .sel (sel),
    .y   (y)
  );

  initial begin
    $dumpfile("tb_mux4.vcd");
    $dumpvars(0, tb_mux4);
  end

  initial begin
    errors = 0;

    // 4 data bits + 2 select bits -> 64 combinations.
    for (i = 0; i < 64; i = i + 1) begin
      {sel, d} = i[5:0];
      #5;
      if (y !== d[sel]) begin
        $display("ERROR: d=%b sel=%0d -> y=%b, expected %b", d, sel, y, d[sel]);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_mux4");
      $finish;
    end else begin
      $display("FAIL: tb_mux4 (%0d errors)", errors);
      $fatal(1, "tb_mux4 failed");
    end
  end

endmodule
