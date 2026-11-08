// tb_cla4.v - exhaustive comparison with the + operator.
`timescale 1ns/1ps

module tb_cla4;

  reg  [3:0] a;
  reg  [3:0] b;
  reg        cin;
  wire [3:0] sum;
  wire       cout;

  integer errors;
  integer i;

  cla4 dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

  initial begin
    $dumpfile("tb_cla4.vcd");
    $dumpvars(0, tb_cla4);
  end

  initial begin
    errors = 0;
    for (i = 0; i < 512; i = i + 1) begin
      {cin, b, a} = i[8:0];
      #2;
      if ({cout, sum} !== a + b + cin) begin
        $display("ERROR: %0d + %0d + %0d = %0d", a, b, cin, {cout, sum});
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_cla4");
      $finish;
    end else begin
      $display("FAIL: tb_cla4 (%0d errors)", errors);
      $fatal(1, "tb_cla4 failed");
    end
  end

endmodule
