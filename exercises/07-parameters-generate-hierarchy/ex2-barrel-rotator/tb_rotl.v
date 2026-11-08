// tb_rotl.v - 8-bit exhaustive and 16-bit random tests of rotl.
`timescale 1ns/1ps

module tb_rotl;

  reg  [7:0]  din8;
  reg  [2:0]  amt8;
  wire [7:0]  dout8;

  reg  [15:0] din16;
  reg  [3:0]  amt16;
  wire [15:0] dout16;

  reg  [7:0]  want8;
  reg  [15:0] want16;
  integer     errors;
  integer     i;
  integer     k;

  rotl #(.WIDTH(8),  .SHIFT_W(3)) r8  (.din(din8),  .amt(amt8),  .dout(dout8));
  rotl #(.WIDTH(16), .SHIFT_W(4)) r16 (.din(din16), .amt(amt16), .dout(dout16));

  initial begin
    $dumpfile("tb_rotl.vcd");
    $dumpvars(0, tb_rotl);
  end

  initial begin
    errors = 0;

    // 8 bits: all 256 x 8 cases. Reference: rotate one step at a time.
    for (i = 0; i < 2048; i = i + 1) begin
      {amt8, din8} = i[10:0];
      #1;
      want8 = din8;
      for (k = 0; k < amt8; k = k + 1)
        want8 = {want8[6:0], want8[7]};
      if (dout8 !== want8) begin
        if (errors < 10)
          $display("ERROR (8): din=%b amt=%0d -> %b, expected %b", din8, amt8, dout8, want8);
        errors = errors + 1;
      end
    end

    // 16 bits: random cases.
    for (i = 0; i < 2000; i = i + 1) begin
      din16 = $random; amt16 = $random;
      #1;
      want16 = din16;
      for (k = 0; k < amt16; k = k + 1)
        want16 = {want16[14:0], want16[15]};
      if (dout16 !== want16) begin
        if (errors < 10)
          $display("ERROR (16): din=%h amt=%0d -> %h, expected %h", din16, amt16, dout16, want16);
        errors = errors + 1;
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_rotl");
      $finish;
    end else begin
      $display("FAIL: tb_rotl (%0d errors)", errors);
      $fatal(1, "tb_rotl failed");
    end
  end

endmodule
