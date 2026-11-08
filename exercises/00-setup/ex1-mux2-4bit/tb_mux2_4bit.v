// tb_mux2_4bit.v - self-checking testbench for exercise 00.1.
`timescale 1ns/1ps

module tb_mux2_4bit;

  reg  [3:0] a;
  reg  [3:0] b;
  reg        sel;
  wire [3:0] y;

  reg  [3:0] expected;
  integer    errors;
  integer    i;

  mux2_4bit dut (
    .a   (a),
    .b   (b),
    .sel (sel),
    .y   (y)
  );

  initial begin
    $dumpfile("tb_mux2_4bit.vcd");
    $dumpvars(0, tb_mux2_4bit);
  end

  initial begin
    errors = 0;

    // 9 input bits -> 512 combinations.
    for (i = 0; i < 512; i = i + 1) begin
      {sel, b, a} = i[8:0];
      #1;
      expected = (a & {4{~sel}}) | (b & {4{sel}});
      if (y !== expected) begin
        if (errors < 10)
          $display("ERROR: a=%h b=%h sel=%b -> y=%h, expected %h",
                   a, b, sel, y, expected);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_mux2_4bit");
      $finish;
    end else begin
      $display("FAIL: tb_mux2_4bit (%0d errors)", errors);
      $fatal(1, "tb_mux2_4bit failed");
    end
  end

endmodule
