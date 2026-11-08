// tb_ripple_adder.v - one module, two widths: 4 bits (exhaustive) and 12 bits (random).
`timescale 1ns/1ps

module tb_ripple_adder;

  // 4-bit instance
  reg  [3:0]  a4, b4;
  reg         cin4;
  wire [3:0]  sum4;
  wire        cout4;

  // 12-bit instance
  reg  [11:0] a12, b12;
  reg         cin12;
  wire [11:0] sum12;
  wire        cout12;

  integer errors;
  integer i;

  // #(.WIDTH(4)) overrides the parameter for this instance only.
  ripple_adder #(.WIDTH(4)) add4 (
    .a(a4), .b(b4), .cin(cin4), .sum(sum4), .cout(cout4)
  );

  ripple_adder #(.WIDTH(12)) add12 (
    .a(a12), .b(b12), .cin(cin12), .sum(sum12), .cout(cout12)
  );

  initial begin
    $dumpfile("tb_ripple_adder.vcd");
    $dumpvars(0, tb_ripple_adder);
  end

  initial begin
    errors = 0;

    for (i = 0; i < 512; i = i + 1) begin
      {cin4, b4, a4} = i[8:0];
      #2;
      if ({cout4, sum4} !== a4 + b4 + cin4) begin
        $display("ERROR (4-bit): %0d + %0d + %0d = %0d", a4, b4, cin4, {cout4, sum4});
        errors = errors + 1;
      end
    end

    for (i = 0; i < 2000; i = i + 1) begin
      a12 = $random; b12 = $random; cin12 = $random;
      #2;
      if ({cout12, sum12} !== a12 + b12 + cin12) begin
        $display("ERROR (12-bit): %0d + %0d + %0d = %0d", a12, b12, cin12, {cout12, sum12});
        errors = errors + 1;
      end
    end

    // Generate blocks have names, so you can reach inside them:
    $display("add12.bit_slice[3].fa.sum = %b (equal to sum12[3] = %b)",
             add12.bit_slice[3].fa.sum, sum12[3]);

    if (errors == 0) begin
      $display("PASS: tb_ripple_adder");
      $finish;
    end else begin
      $display("FAIL: tb_ripple_adder (%0d errors)", errors);
      $fatal(1, "tb_ripple_adder failed");
    end
  end

endmodule
