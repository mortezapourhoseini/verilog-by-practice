// tb_decoder3to8.v - exhaustive testbench for exercise 04.1.
`timescale 1ns/1ps

module tb_decoder3to8;

  reg        en;
  reg  [2:0] sel;
  wire [7:0] y;

  reg  [7:0] want;
  integer    errors;
  integer    i;
  integer    k;

  decoder3to8 dut (
    .en  (en),
    .sel (sel),
    .y   (y)
  );

  initial begin
    $dumpfile("tb_decoder3to8.vcd");
    $dumpvars(0, tb_decoder3to8);
  end

  initial begin
    errors = 0;

    // Go through the inputs twice in different orders. A latch would
    // show up as an output that remembers an old value.
    for (k = 0; k < 2; k = k + 1) begin
      for (i = 0; i < 16; i = i + 1) begin
        if (k == 0) {en, sel} = i[3:0];
        else        {en, sel} = 15 - i;
        #5;
        want = 8'd0;
        if (en) want[sel] = 1'b1;
        if (y !== want) begin
          $display("ERROR: en=%b sel=%0d -> y=%b, expected %b", en, sel, y, want);
          errors = errors + 1;
        end
      end
    end

    if (errors == 0) begin
      $display("PASS: tb_decoder3to8");
      $finish;
    end else begin
      $display("FAIL: tb_decoder3to8 (%0d errors)", errors);
      $fatal(1, "tb_decoder3to8 failed");
    end
  end

endmodule
