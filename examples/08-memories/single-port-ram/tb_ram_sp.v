// tb_ram_sp.v - random reads and writes compared with a model memory.
`timescale 1ns/1ps

module tb_ram_sp;

  reg        clk;
  reg        we;
  reg  [3:0] addr;
  reg  [7:0] din;
  wire [7:0] dout;

  reg  [7:0] model [0:15];
  reg  [7:0] expected;
  reg        check_next;
  integer    errors;
  integer    t;
  integer    k;

  ram_sp #(.DATA_W(8), .ADDR_W(4)) dut (
    .clk  (clk),
    .we   (we),
    .addr (addr),
    .din  (din),
    .dout (dout)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_ram_sp.vcd");
    $dumpvars(0, tb_ram_sp);
  end

  // Model: at each edge, remember what dout must show after the edge
  // (the OLD contents, read-first), then apply the write.
  always @(posedge clk) begin
    expected   <= model[addr];
    check_next <= 1'b1;
    if (we) model[addr] <= din;
  end

  always @(negedge clk) begin
    if (check_next && dout !== expected) begin
      if (errors < 10)
        $display("ERROR at %0t: dout=%h, expected %h", $time, dout, expected);
      errors = errors + 1;
    end
  end

  initial begin
    errors = 0;
    check_next = 1'b0;
    we = 1'b0; addr = 4'd0; din = 8'd0;

    // 1. Fill the memory: write address k with the value 16*k + 1.
    for (k = 0; k < 16; k = k + 1) begin
      @(negedge clk);
      we = 1'b1; addr = k; din = 16 * k + 1;
    end
    @(negedge clk);
    we = 1'b0;

    // 2. Read-first on purpose: write and read the same address.
    addr = 4'd5; din = 8'hAA; we = 1'b1;
    @(negedge clk);
    $display("write 0xAA to address 5: dout shows the old value %h", dout);
    we = 1'b0;
    @(negedge clk);
    $display("next cycle: dout shows the new value %h", dout);

    // 3. Random traffic.
    for (t = 0; t < 1000; t = t + 1) begin
      @(negedge clk);
      we = $random; addr = $random; din = $random;
    end
    @(negedge clk);

    if (errors == 0) begin
      $display("PASS: tb_ram_sp");
      $finish;
    end else begin
      $display("FAIL: tb_ram_sp (%0d errors)", errors);
      $fatal(1, "tb_ram_sp failed");
    end
  end

endmodule
