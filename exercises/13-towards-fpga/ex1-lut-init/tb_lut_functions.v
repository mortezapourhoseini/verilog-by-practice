// tb_lut_functions.v - checks all four LUT functions on all 16 inputs.
`timescale 1ns/1ps

module tb_lut_functions;

  reg  [3:0] in;
  wire       f_mux;
  wire       f_and4;
  wire       f_xor4;
  wire       f_atleast2;

  integer errors;
  integer n;

  lut_functions dut (
    .in(in), .f_mux(f_mux), .f_and4(f_and4), .f_xor4(f_xor4), .f_atleast2(f_atleast2)
  );

  initial begin
    $dumpfile("tb_lut_functions.vcd");
    $dumpvars(0, tb_lut_functions);
  end

  initial begin
    errors = 0;
    for (n = 0; n < 16; n = n + 1) begin
      in = n;
      #5;
      if (f_mux !== (in[2] ? in[1] : in[0])) begin
        $display("ERROR: f_mux wrong for in=%b", in);
        errors = errors + 1;
      end
      if (f_and4 !== (&in)) begin
        $display("ERROR: f_and4 wrong for in=%b", in);
        errors = errors + 1;
      end
      if (f_xor4 !== (^in)) begin
        $display("ERROR: f_xor4 wrong for in=%b", in);
        errors = errors + 1;
      end
      if (f_atleast2 !== ((in[0] + in[1] + in[2] + in[3]) >= 2)) begin
        $display("ERROR: f_atleast2 wrong for in=%b", in);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_lut_functions");
      $finish;
    end else begin
      $display("FAIL: tb_lut_functions (%0d errors)", errors);
      $fatal(1, "tb_lut_functions failed");
    end
  end

endmodule
