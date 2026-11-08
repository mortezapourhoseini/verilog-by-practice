// tb_multipliers.v - exhaustive test of mult8, random test of mult_seq8.
`timescale 1ns/1ps

module tb_multipliers;

  // combinational multiplier
  reg  [7:0]  a;
  reg  [7:0]  b;
  reg         is_signed;
  wire [15:0] p;

  // sequential multiplier
  reg         clk;
  reg         rst;
  reg         start;
  reg  [7:0]  sa;
  reg  [7:0]  sb;
  wire [15:0] product;
  wire        done;
  wire        busy;

  integer ia, ib;       // operands as integers (signed when needed)
  integer want;
  integer errors;
  integer i;
  integer j;
  integer t;
  integer cycles;

  mult8 u_comb (.a(a), .b(b), .is_signed(is_signed), .p(p));

  mult_seq8 u_seq (
    .clk(clk), .rst(rst), .start(start), .a(sa), .b(sb),
    .product(product), .done(done), .busy(busy)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_multipliers.vcd");
    $dumpvars(0, tb_multipliers);
    #2000 $dumpoff;
  end

  initial begin
    errors = 0;

    // 1. Combinational: every a, b, both modes. The reference uses
    //    integers, which are signed 32-bit values in Verilog.
    for (i = 0; i < 256; i = i + 1) begin
      for (j = 0; j < 256; j = j + 1) begin
        a = i; b = j;
        is_signed = 1'b0;
        #1;
        if (p !== i * j) begin
          if (errors < 10) $display("ERROR unsigned: %0d * %0d = %0d", a, b, p);
          errors = errors + 1;
        end
        is_signed = 1'b1;
        #1;
        ia = (i > 127) ? i - 256 : i;
        ib = (j > 127) ? j - 256 : j;
        want = ia * ib;
        if (p !== want[15:0]) begin
          if (errors < 10) $display("ERROR signed: %0d * %0d = %0d", ia, ib, $signed(p));
          errors = errors + 1;
        end
      end
    end
    $display("mult8: %0d signed and unsigned cases checked", 2 * 256 * 256);

    // 2. Sequential: random operands, wait for done.
    rst = 1'b1; start = 1'b0; sa = 0; sb = 0;
    repeat (2) @(negedge clk);
    rst = 1'b0;
    for (t = 0; t < 300; t = t + 1) begin
      sa = $random; sb = $random;
      if (t == 0) begin sa = 8'd255; sb = 8'd255; end   // the largest case
      start = 1'b1;
      @(negedge clk);
      start = 1'b0;
      cycles = 0;
      while (!done && cycles < 20) begin
        @(negedge clk);
        cycles = cycles + 1;
      end
      if (!done || product !== sa * sb) begin
        $display("ERROR seq: %0d * %0d = %0d (done=%b)", sa, sb, product, done);
        errors = errors + 1;
      end
      if (t == 0) $display("mult_seq8: 255 * 255 = %0d after %0d cycles", product, cycles + 1);
    end

    if (errors == 0) begin
      $display("PASS: tb_multipliers");
      $finish;
    end else begin
      $display("FAIL: tb_multipliers (%0d errors)", errors);
      $fatal(1, "tb_multipliers failed");
    end
  end

endmodule
