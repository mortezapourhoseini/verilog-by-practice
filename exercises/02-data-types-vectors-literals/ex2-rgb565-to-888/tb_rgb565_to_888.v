// tb_rgb565_to_888.v - exhaustive testbench for exercise 02.2.
`timescale 1ns/1ps

module tb_rgb565_to_888;

  reg  [15:0] pix;
  wire [7:0]  r8;
  wire [7:0]  g8;
  wire [7:0]  b8;

  reg  [4:0] r5;
  reg  [5:0] g6;
  reg  [4:0] b5;
  reg  [7:0] want_r;
  reg  [7:0] want_g;
  reg  [7:0] want_b;
  integer    errors;
  integer    i;

  rgb565_to_888 dut (
    .pix (pix),
    .r8  (r8),
    .g8  (g8),
    .b8  (b8)
  );

  initial begin
    $dumpfile("tb_rgb565_to_888.vcd");
    $dumpvars(0, tb_rgb565_to_888);
    #1000 $dumpoff;   // keep the waveform file small
  end

  initial begin
    errors = 0;

    for (i = 0; i < 65536; i = i + 1) begin
      pix = i[15:0];
      #1;
      // Reference model with shifts instead of part selects.
      // Assigning to a narrower reg keeps only the low bits.
      r5 = pix >> 11;
      g6 = pix >> 5;
      b5 = pix;
      want_r = (r5 << 3) | (r5 >> 2);
      want_g = (g6 << 2) | (g6 >> 4);
      want_b = (b5 << 3) | (b5 >> 2);
      if (r8 !== want_r || g8 !== want_g || b8 !== want_b) begin
        if (errors < 10)
          $display("ERROR: pix=%h -> %h %h %h, expected %h %h %h",
                   pix, r8, g8, b8, want_r, want_g, want_b);
        errors = errors + 1;
      end
    end

    // Two spot checks from the README.
    pix = 16'hFFFF; #1;
    if (r8 !== 8'd255 || g8 !== 8'd255 || b8 !== 8'd255) errors = errors + 1;
    pix = 16'h0000; #1;
    if (r8 !== 8'd0 || g8 !== 8'd0 || b8 !== 8'd0) errors = errors + 1;

    if (errors == 0) begin
      $display("PASS: tb_rgb565_to_888");
      $finish;
    end else begin
      $display("FAIL: tb_rgb565_to_888 (%0d errors)", errors);
      $fatal(1, "tb_rgb565_to_888 failed");
    end
  end

endmodule
