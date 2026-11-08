// tb_full_adder_luts.v - the LUT version must equal a + b + cin.
`timescale 1ns/1ps

module tb_full_adder_luts;

  reg  a;
  reg  b;
  reg  cin;
  wire sum;
  wire cout;

  integer errors;
  integer i;

  full_adder_luts dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

  initial begin
    $dumpfile("tb_full_adder_luts.vcd");
    $dumpvars(0, tb_full_adder_luts);
  end

  initial begin
    errors = 0;
    for (i = 0; i < 8; i = i + 1) begin
      {cin, b, a} = i[2:0];
      #5;
      if ({cout, sum} !== a + b + cin) begin
        $display("ERROR: %b + %b + %b -> cout=%b sum=%b", a, b, cin, cout, sum);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_full_adder_luts");
      $finish;
    end else begin
      $display("FAIL: tb_full_adder_luts (%0d errors)", errors);
      $fatal(1, "tb_full_adder_luts failed");
    end
  end

endmodule
