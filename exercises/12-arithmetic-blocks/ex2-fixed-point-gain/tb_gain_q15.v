// tb_gain_q15.v - corner cases and random values against an integer model.
`timescale 1ns/1ps

module tb_gain_q15;

  reg  [15:0] x;
  reg  [15:0] g;
  wire [15:0] y;

  integer ix, ig, q, want;
  integer errors;
  integer t;

  gain_q15 dut (.x(x), .g(g), .y(y));

  initial begin
    $dumpfile("tb_gain_q15.vcd");
    $dumpvars(0, tb_gain_q15);
  end

  // Reference: round half up, then saturate. Uses division, not shifts.
  function integer model;
    input integer a;
    input integer b;
    integer p;
    begin
      p = a * b + 16384;                     // Q2.30 plus half an LSB
      if (p >= 0) p = p / 32768;
      else        p = -((-p + 32767) / 32768);   // floor for negative values
      if (p > 32767)  p = 32767;
      if (p < -32768) p = -32768;
      model = p;
    end
  endfunction

  task check;
    begin
      #1;
      ix = x[15] ? x - 65536 : x;
      ig = g[15] ? g - 65536 : g;
      want = model(ix, ig);
      if (y !== want[15:0]) begin
        if (errors < 10)
          $display("ERROR: %0d * %0d (%f * %f) -> %h, expected %h",
                   ix, ig, ix / 32768.0, ig / 32768.0, y, want[15:0]);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;

    x = 16'h4000; g = 16'h4000; check;   //  0.5  *  0.5
    x = 16'hC000; g = 16'h4000; check;   // -0.5  *  0.5
    x = 16'h8000; g = 16'h8000; check;   // -1.0  * -1.0 -> saturates
    x = 16'h8000; g = 16'h7FFF; check;   // -1.0  *  0.99997
    x = 16'h0001; g = 16'h4000; check;   // rounding up
    x = 16'hFFFF; g = 16'h4000; check;   // -1 LSB * 0.5 = -0.5 LSB -> rounds to 0
    x = 16'h7FFF; g = 16'h7FFF; check;
    x = 16'h0000; g = 16'h8000; check;

    for (t = 0; t < 20000; t = t + 1) begin
      x = $random;
      g = $random;
      check;
    end

    if (errors == 0) begin
      $display("PASS: tb_gain_q15");
      $finish;
    end else begin
      $display("FAIL: tb_gain_q15 (%0d errors)", errors);
      $fatal(1, "tb_gain_q15 failed");
    end
  end

endmodule
