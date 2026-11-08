// tb_muxn.v - two differently sized instances of muxn.
`timescale 1ns/1ps

module tb_muxn;

  // Instance A: WIDTH = 8, N = 4, SEL_W = 2
  reg  [31:0] da;
  reg  [1:0]  sela;
  wire [7:0]  ya;

  // Instance B: WIDTH = 3, N = 5, SEL_W = 3
  reg  [14:0] db;
  reg  [2:0]  selb;
  wire [2:0]  yb;

  reg  [7:0] want_a;
  reg  [2:0] want_b;
  integer    errors;
  integer    t;

  muxn #(.WIDTH(8), .N(4), .SEL_W(2)) mux_a (.d(da), .sel(sela), .y(ya));
  muxn #(.WIDTH(3), .N(5), .SEL_W(3)) mux_b (.d(db), .sel(selb), .y(yb));

  initial begin
    $dumpfile("tb_muxn.vcd");
    $dumpvars(0, tb_muxn);
  end

  initial begin
    errors = 0;

    for (t = 0; t < 1000; t = t + 1) begin
      da = $random; sela = $random;
      db = $random; selb = $random;
      #2;
      // Reference: shift right, keep the low bits.
      want_a = da >> (8 * sela);
      want_b = (selb < 5) ? (db >> (3 * selb)) : 3'd0;
      if (ya !== want_a) begin
        $display("ERROR A: d=%h sel=%0d -> %h, expected %h", da, sela, ya, want_a);
        errors = errors + 1;
      end
      if (yb !== want_b) begin
        $display("ERROR B: d=%b sel=%0d -> %b, expected %b", db, selb, yb, want_b);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_muxn");
      $finish;
    end else begin
      $display("FAIL: tb_muxn (%0d errors)", errors);
      $fatal(1, "tb_muxn failed");
    end
  end

endmodule
