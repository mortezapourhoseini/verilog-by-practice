// tb_sort3.v - constrained random stimulus, property checks and coverage.
//
// Run with a different seed:
//   vvp <file>.vvp +seed=42
`timescale 1ns/1ps

module tb_sort3;

  reg  [7:0] a, b, c;
  wire [7:0] lo, mid, hi;

  integer seed;
  integer errors;
  integer t;
  integer kind;

  // Coverage counters: did we really test the interesting cases?
  integer cov_all_equal;
  integer cov_two_equal;
  integer cov_all_diff;
  integer cov_has_zero;
  integer cov_has_max;
  integer cov_order [0:5];   // which of the 6 input orders appeared
  integer k;

  sort3 dut (.a(a), .b(b), .c(c), .lo(lo), .mid(mid), .hi(hi));

  initial begin
    $dumpfile("tb_sort3.vcd");
    $dumpvars(0, tb_sort3);
    #500 $dumpoff;
  end

  // Choose one random byte with a "constraint": small values, big values,
  // the edges 0 and 255, or anything. $random(seed) changes seed, so the
  // whole sequence depends only on the start seed.
  function [7:0] pick;
    input integer mode;
    begin
      case (mode)
        0: pick = $random(seed) & 3;              // 0..3
        1: pick = 8'd252 + ($random(seed) & 3);   // 252..255
        2: pick = 8'd0;
        3: pick = 8'd255;
        default: pick = $random(seed);            // anything
      endcase
    end
  endfunction

  // Property checks: no reference sort needed.
  task check;
    begin
      #1;
      // 1. The output is ordered.
      if (!(lo <= mid && mid <= hi)) begin
        $display("ERROR: not sorted: %0d %0d %0d -> %0d %0d %0d", a, b, c, lo, mid, hi);
        errors = errors + 1;
      end
      // 2. The output is a permutation of the input: same sum, same
      //    minimum, same maximum (enough for three values).
      //    {2'b00, lo} makes the sums 10 bits wide, so they cannot overflow.
      if ({2'b00, lo} + mid + hi !== {2'b00, a} + b + c ||
          lo !== ((a < b) ? ((a < c) ? a : c) : ((b < c) ? b : c)) ||
          hi !== ((a > b) ? ((a > c) ? a : c) : ((b > c) ? b : c))) begin
        $display("ERROR: not a permutation: %0d %0d %0d -> %0d %0d %0d", a, b, c, lo, mid, hi);
        errors = errors + 1;
      end
      // Coverage.
      if (a == b && b == c)                  cov_all_equal = cov_all_equal + 1;
      else if (a == b || b == c || a == c)   cov_two_equal = cov_two_equal + 1;
      else                                   cov_all_diff  = cov_all_diff + 1;
      if (a == 0 || b == 0 || c == 0)         cov_has_zero  = cov_has_zero + 1;
      if (a == 255 || b == 255 || c == 255)   cov_has_max   = cov_has_max + 1;
      if (a < b && b < c) cov_order[0] = cov_order[0] + 1;
      if (a < c && c < b) cov_order[1] = cov_order[1] + 1;
      if (b < a && a < c) cov_order[2] = cov_order[2] + 1;
      if (b < c && c < a) cov_order[3] = cov_order[3] + 1;
      if (c < a && a < b) cov_order[4] = cov_order[4] + 1;
      if (c < b && b < a) cov_order[5] = cov_order[5] + 1;
    end
  endtask

  initial begin
    errors = 0;
    cov_all_equal = 0; cov_two_equal = 0; cov_all_diff = 0;
    cov_has_zero = 0; cov_has_max = 0;
    for (k = 0; k < 6; k = k + 1) cov_order[k] = 0;

    // Default seed, or the one given on the command line.
    seed = 1;
    if ($value$plusargs("seed=%d", seed))
      $display("using seed %0d from the command line", seed);
    else
      $display("using the default seed %0d (change it with +seed=N)", seed);

    for (t = 0; t < 5000; t = t + 1) begin
      // Weighted choice: mode 4 ("anything") is the most frequent.
      // $random can be negative, and % keeps the sign: -7 % 10 = -7.
      kind = $random(seed) % 10;
      if (kind < 0) kind = -kind;
      if (kind > 4) kind = 4;
      a = pick(kind);
      b = pick(($random(seed) & 7) > 3 ? kind : 4);
      c = pick(($random(seed) & 7) > 5 ? kind : 4);
      check;
    end

    $display("coverage: all equal %0d, two equal %0d, all different %0d",
             cov_all_equal, cov_two_equal, cov_all_diff);
    $display("coverage: with 0: %0d, with 255: %0d", cov_has_zero, cov_has_max);
    for (k = 0; k < 6; k = k + 1)
      if (cov_order[k] == 0) begin
        $display("ERROR: input order %0d never tested", k);
        errors = errors + 1;
      end
    if (cov_all_equal == 0 || cov_two_equal == 0) begin
      $display("ERROR: equal values were never tested: improve the stimulus");
      errors = errors + 1;
    end

    if (errors == 0) begin
      $display("PASS: tb_sort3");
      $finish;
    end else begin
      $display("FAIL: tb_sort3 (%0d errors)", errors);
      $fatal(1, "tb_sort3 failed");
    end
  end

endmodule
