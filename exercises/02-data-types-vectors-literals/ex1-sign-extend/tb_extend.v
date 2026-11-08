// tb_extend.v - self-checking testbench for exercise 02.1.
`timescale 1ns/1ps

module tb_extend;

  reg  [7:0]  in;
  wire [15:0] zext;
  wire [15:0] sext;

  reg  signed [7:0]  in_s;     // the same bits, seen as signed
  reg  signed [15:0] want_s;
  integer errors;
  integer i;

  extend dut (
    .in   (in),
    .zext (zext),
    .sext (sext)
  );

  initial begin
    $dumpfile("tb_extend.vcd");
    $dumpvars(0, tb_extend);
  end

  initial begin
    errors = 0;

    for (i = 0; i < 256; i = i + 1) begin
      in = i[7:0];
      #2;
      // The reference model lets Verilog do the extension:
      // unsigned 8-bit into 16 bits -> zero extension,
      // signed 8-bit into signed 16 bits -> sign extension.
      in_s   = in;
      want_s = in_s;
      if (zext !== {8'd0, in} || sext !== want_s) begin
        if (errors < 10)
          $display("ERROR: in=%h -> zext=%h sext=%h, expected %h %h",
                   in, zext, sext, {8'd0, in}, want_s);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_extend");
      $finish;
    end else begin
      $display("FAIL: tb_extend (%0d errors)", errors);
      $fatal(1, "tb_extend failed");
    end
  end

endmodule
