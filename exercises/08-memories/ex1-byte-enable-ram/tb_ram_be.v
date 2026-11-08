// tb_ram_be.v - random byte writes compared with a model memory.
`timescale 1ns/1ps

module tb_ram_be;

  reg         clk;
  reg  [3:0]  be;
  reg  [3:0]  addr;
  reg  [31:0] din;
  wire [31:0] dout;

  reg  [31:0] model [0:15];
  reg  [31:0] expected;
  reg  [31:0] mask;
  integer     errors;
  integer     t;
  integer     k;

  ram_be dut (
    .clk  (clk),
    .be   (be),
    .addr (addr),
    .din  (din),
    .dout (dout)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_ram_be.vcd");
    $dumpvars(0, tb_ram_be);
  end

  always @(posedge clk) begin
    expected <= model[addr];
    // Build a bit mask from the byte enables: be = 0010 -> 0000ff00.
    mask = {{8{be[3]}}, {8{be[2]}}, {8{be[1]}}, {8{be[0]}}};
    model[addr] <= (model[addr] & ~mask) | (din & mask);
  end

  initial begin
    errors = 0;
    be = 4'b0000; addr = 0; din = 0;

    // Fill every word with a known value, using all four enables.
    for (k = 0; k < 16; k = k + 1) begin
      @(negedge clk);
      be = 4'b1111; addr = k; din = {4{k[3:0], 4'hA}};
    end

    // Random byte writes and reads. Check dout one edge later.
    for (t = 0; t < 2000; t = t + 1) begin
      @(negedge clk);
      if (t > 0 && dout !== expected) begin
        if (errors < 10)
          $display("ERROR at %0t: dout=%h, expected %h", $time, dout, expected);
        errors = errors + 1;
      end
      be = $random; addr = $random; din = $random;
    end

    if (errors == 0) begin
      $display("PASS: tb_ram_be");
      $finish;
    end else begin
      $display("FAIL: tb_ram_be (%0d errors)", errors);
      $fatal(1, "tb_ram_be failed");
    end
  end

endmodule
